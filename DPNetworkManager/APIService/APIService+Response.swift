//
//  APIService+Response.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

extension APIService {
    
    func success(response: DPResponse) -> Bool? {
        let baseResponse = response.baseResponseModel(BaseResponse.self)
        if baseResponse?.status == true && response.isSuccess {
            return true
        }
        return false
    }
    
    func error(response: DPResponse) -> Error? {
        if response.error != nil {
            // Or you can override default error messages
            return response.error
        }
        let baseResponse = response.baseResponseModel(BaseResponse.self)
        return NSError(domain: "ERROR_DOMAIN", code: response.httpStatusCode?.rawValue ?? 0, userInfo: [NSLocalizedDescriptionKey: baseResponse?.message ?? response.message ?? "Something went wrong"])
    }
    
    func message(response: DPResponse) -> String? {
        let baseResponse = response.baseResponseModel(BaseResponse.self)
        return baseResponse?.message ?? response.message
    }
    
}
