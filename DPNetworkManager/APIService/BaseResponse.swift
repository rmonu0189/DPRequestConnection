//
//  BaseResponse.swift
//   DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

struct BaseResponse: Codable {
    let status: Bool
    let message: String
}
