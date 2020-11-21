//
//  APIService+RequestBody.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

extension APIService {
    
    func requestBody() -> DPRequestBody {
        switch self {
        case let .login(user):
            return DPRequestBody(model: user)
        case let .signUp(user):
            return DPRequestBody(model: user)
        }
    }
    
}
