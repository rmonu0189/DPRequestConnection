//
//  DPResponse.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

struct DPResponse {
    
    private var service: DPRequestProtocol
    var headers: [String: Any]?
    var url: URL?
    var result: Data?
    var httpStatusCode: DPHTTPStatusCode?
    
    var isSuccess: Bool = false
    var error: Error?
    var message: String?
        
    init(data: Data?, response: URLResponse?, error: Error?, service: DPRequestProtocol) {
        self.result = data
        self.error = error
        self.url = response?.url
        self.service = service
        if let httpUrlResponse = response as? HTTPURLResponse {
            self.httpStatusCode = DPHTTPStatusCode(rawValue: httpUrlResponse.statusCode)
            self.message = httpStatusCode?.statusDescription
            self.headers = httpUrlResponse.allHeaderFields as? [String: Any]
            if httpUrlResponse.statusCode >= 200 && httpUrlResponse.statusCode <= 299 {
                self.isSuccess = true
            }
        }
        
        if let isSuccess = service.success(response: self) {
            self.isSuccess = isSuccess
        }
        
        if let errorResponse = service.error(response: self) {
            self.error = errorResponse
        }
        
        if let message = service.message(response: self) {
            self.message = message
        }
    }
    
    func decodeResponseToModel<T: Codable>(_ service: DPRequestProtocol, type: T.Type) -> T? {
        if let key = service.responseKey() {
            let value = jsonResponse()[key]
            return decodeFromJSON(T.self, data: value, service: service)
        } else if let json = service.responseModelFromJSON(jsonResponse()) {
            return decodeFromJSON(T.self, data: json, service: service)
        } else if let json = service.responseModelFromData(result) {
            return decodeFromJSON(T.self, data: json, service: service)
        } else {
            return decodeFromJSON(T.self, data: jsonResponse(), service: service)
        }
    }
    
    func decodeResponseToModelList<T: Codable>(_ service: DPRequestProtocol, type: T.Type) -> [T]? {
        if let key = service.responseKey() {
            let value = jsonResponse()[key]
            return decodeFromJSONList(T.self, data: value, service: service)
        } else if let json = service.responseModelFromJSON(jsonResponse()) {
            return decodeFromJSONList(T.self, data: json, service: service)
        } else if let json = service.responseModelFromData(result) {
            return decodeFromJSONList(T.self, data: json, service: service)
        } else {
            return decodeFromJSONList(T.self, data: jsonResponse(), service: service)
        }
    }
    
    func baseResponseModel<T: Codable>(_ type: T.Type) -> T? {
        return decodeFromJSON(T.self, data: jsonResponse(), service: self.service)
    }
    
    private func jsonResponse() -> [String: Any] {
        guard let data = result else { return [:] }
        do {
            let apiResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            return apiResponse ?? [:]
        } catch {
            DPLogger.log(error)
            return [:]
        }
    }
    
    private func decodeFromJSON<T: Codable>(_: T.Type, data: Any?, service: DPRequestProtocol) -> T? {
        do {
            guard let inputData = data else { return nil }
            let resultsData = try JSONSerialization.data(withJSONObject: inputData, options: .prettyPrinted)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let strategy = service.dateDecodingStrategy() {
                decoder.dateDecodingStrategy = strategy
            }
            return try decoder.decode(T.self, from: resultsData)
        } catch {
            DPLogger.log(error)
            return nil
        }
    }
    
    private func decodeFromJSONList<T: Codable>(_: T.Type, data: Any?, service: DPRequestProtocol) -> [T]? {
        do {
            guard let inputData = data else { return nil }
            let resultsData = try JSONSerialization.data(withJSONObject: inputData, options: .prettyPrinted)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let strategy = service.dateDecodingStrategy() {
                decoder.dateDecodingStrategy = strategy
            }
            return try decoder.decode([T].self, from: resultsData)
        } catch {
            DPLogger.log(error)
            return nil
        }
    }
    
}
