//
//  DPRequestConnection.swift
//  DPRequestConnection
//
//  Created by Monu Rathor on 20/11/20.
//

import Foundation

final class DPRequestConnection {
        
    fileprivate var urlSession: URLSession
    
    // MARK: - Singleton Instance
    class var shared: DPRequestConnection {
        struct Singleton {
            static let instance = DPRequestConnection()
        }
        return Singleton.instance
    }
    
    private init() {
        urlSession = URLSession(configuration: DPRequestConnectionConfiguration.shared.configuration)
    }
        
    /**
     Perform request to fetch data
     - parameter request:           request
     - parameter userInfo:          userinfo
     - parameter completionHandler: handler
     */
    func performService(_ service: DPRequestProtocol, completionHandler: @escaping (_ response: DPResponse) -> Void) {
        let request = service.prepareRequest()
        urlSession.dataTask(with: request) { (data, response, error) in
            let dataResponse = DPResponse(data: data, response: response, error: error, service: service)
            DispatchQueue.main.async {
                completionHandler(dataResponse)
            }
        }.resume()
    }
    
}
