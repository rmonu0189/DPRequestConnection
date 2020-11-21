//
//  DPRequestProtocol.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

protocol DPRequestProtocol {
    
    func baseUrl() -> String?
    func requestBody() -> DPRequestBody
    func requestPath() -> DPRequestPath
    func commonHeaders() -> [String: Any]
    func responseKey() -> String?
    func responseModelFromJSON(_ json: [String: Any]) -> Any?
    func responseModelFromData(_ data: Data?) -> Any?
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy?
    func dateEncodingStrategy() -> JSONEncoder.DateEncodingStrategy?
    
    func success(response: DPResponse) -> Bool?
    func error(response: DPResponse) -> Error?
    func message(response: DPResponse) -> String?
}

extension DPRequestProtocol {
    func commonHeaders() -> [String: Any] { return [:] }
    func baseUrl() -> String? { return nil }
    func responseKey() -> String? { return nil }
    func responseModelFromJSON(_ json: [String: Any]) -> Any? { return nil }
    func responseModelFromData(_ data: Data?) -> Any? { return nil }
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy? { return nil }
    func dateEncodingStrategy() -> JSONEncoder.DateEncodingStrategy? { return nil }
    func success(response: DPResponse) -> Bool? { return nil }
    func error(response: DPResponse) -> Error? { return nil }
    func message(response: DPResponse) -> String? { return nil }
}
