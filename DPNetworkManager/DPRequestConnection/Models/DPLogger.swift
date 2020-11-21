//
//  DPLogger.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 21/11/20.
//

import Foundation

struct DPLogger {
    
    static func log(_ message: Any...) {
        if DPRequestConnectionConfiguration.shared.isLogging {
            if message.count > 1 {
                debugPrint(message)
            } else {
                debugPrint(message.first ?? "")
            }
        }
    }

}
