//
//  URLRequest+PrepareBody.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

extension URLRequest {
    
    mutating func prepareBody(_ requestBody: DPRequestBody, service: DPRequestProtocol) {
        switch requestBody.bodyEncodeType {
        case .json:
            prepareJSONBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        case .formData:
            prepareFormDataBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        case .formUrlEncoded:
            prepareFormURLEncodedBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        default:
            prepareGETBody(requestBody, dateEncodingStrategy: service.dateEncodingStrategy())
        }
    }
    
    private mutating func prepareGETBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        // Prepare query items
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            if let item = value as? String {
                queryItems.append(URLQueryItem(name: key, value: item))
            } else {
                queryItems.append(URLQueryItem(name: key, value: (value as AnyObject).description))
            }
        }
        // Assign query items
        var components = URLComponents(string: self.url?.absoluteString ?? "")
        components?.queryItems = queryItems
        self.url = components?.url
    }
    
    private mutating func prepareJSONBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            self.httpBody = data
            self.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch let parseError {
            DPLogger.log(parseError)
        }
    }
    
    private mutating func prepareFormDataBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        var data = [String]()
        for (key, value) in params {
            data.append(key + "=\(value)")
        }
        let formDataBody = data.map { String($0) }.joined(separator: "&")
        self.httpBody = formDataBody.data(using: .utf8)
    }
    
    private mutating func prepareFormURLEncodedBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        
        // Append parameters body
        for (key, value) in params {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(key)\""
            body += "\r\n\r\n\(value)\r\n"
        }
        
        // Append Files
        for (name, file) in (requestBody.files ?? [:]) {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(name)\""
            body += "; filename=\"\(name)\"\r\n"
            let fileData = String(data: file, encoding: .utf8) ?? ""
            body += "Content-Type: \"content-type header\"\r\n\r\n\(fileData)\r\n"
        }
        
        // Close boundary
        body += "--\(boundary)--\r\n";
        
        let postData = body.data(using: .utf8)
        self.httpBody = postData
        self.addValue(postData?.count.description ?? "", forHTTPHeaderField: "Content-Length")
        self.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
    
    private mutating func prepareTextBody(_ requestBody: DPRequestBody, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) {
        let params = requestBody.getBodyDictionary(dateEncodingStrategy)
        var data = [String]()
        for (key, value) in params {
            data.append(key + ":\(value)")
        }
    }
}

extension DPRequestBody {
    
    fileprivate func getBodyDictionary(_ dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) -> [String: Any] {
        if let body = self.model {
            return body.toJSONRequest(self.keyEncodingStrategy, dateEncodingStrategy: dateEncodingStrategy)
        } else if let body = self.bodyInKeyValuePair {
            return body
        }
        return [:]
    }
    
}

extension Encodable {
    
    fileprivate func toJSONRequest(_ keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy?, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy?) -> [String: Any] {
        do {
            let encoder = JSONEncoder()
            if let strategy = keyEncodingStrategy { encoder.keyEncodingStrategy = strategy }
            if let strategy = dateEncodingStrategy { encoder.dateEncodingStrategy = strategy }
            let jsonData = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
            return json as? [String: Any] ?? [:]
        } catch {
            DPLogger.log(error)
            return [:]
        }
    }
    
}
