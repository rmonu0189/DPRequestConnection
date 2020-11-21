//
//  APIService.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

enum APIService: DPRequestProtocol {
    
    case login(user: User)
    case signUp(user: User)
    
    func baseUrl() -> String? {
        return "https://us-central1-blog6ix-sample.cloudfunctions.net/api/v1"
    }
    
    func commonHeaders() -> [String: Any] {
        return [:]
    }
    
}
