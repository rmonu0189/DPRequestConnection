//
//  DPRequest.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 20/11/20.
//

import Foundation

struct DPRequestBody {
    
    var headers: [String: Any]?
    var model: Codable?
    var bodyInKeyValuePair: [String: Any]?
    var bodyEncodeType: DPRequestBodyEncodeType?
    var data: Data?
    var files: [String: Data]?
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy?
    
}
