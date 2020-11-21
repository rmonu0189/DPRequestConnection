//
//  APIService+RequestPath.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

extension APIService {
    
    func requestPath() -> DPRequestPath {
        switch self {
        case .login:
            return DPRequestPath(method: .POST, endPoint: "/auth/login")
        case .signUp:
            return DPRequestPath(method: .POST, endPoint: "/auth/signup")
        }
    }
    
}
