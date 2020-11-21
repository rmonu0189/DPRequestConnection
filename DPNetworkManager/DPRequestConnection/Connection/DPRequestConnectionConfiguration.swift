//
//  DPRequestConnectionConfiguration.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 20/11/20.
//

import Foundation

final class DPRequestConnectionConfiguration {
    
    fileprivate init() { }
    
    // Public Configurations
    var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    var authenticationTokenKeyInHeader: String?
    var isLogging: Bool = false
    var timeoutInterval: TimeInterval = 30
    
    // MARK: - Singleton Instance
    class var shared: DPRequestConnectionConfiguration {
        struct Singleton {
            static let instance = DPRequestConnectionConfiguration()
        }
        return Singleton.instance
    }
    
}
