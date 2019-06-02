//
//  NetworkCheckOperation.swift
//  Phoenix
//
//  Created by Anthony Persaud on 6/2/19.
//  Copyright © 2019 Modernistik. All rights reserved.
//

import Foundation
import Modernistik
import Alamofire

class NetworkCheckOperation : Worker {
    
    let networkManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    override func work() {
        guard let networkManager = networkManager else {
            log("Failed to create network manager")
            return failed()
        }
        
        if networkManager.isReachable { return completed() }
        log("Waiting for network availability.")
        
        networkManager.listener = { [weak self] (status) in
            
            if networkManager.isReachable {
                self?.log("Network available.... completing task.")
                networkManager.stopListening()
                networkManager.listener = nil
                self?.completed()
            }
        }
        networkManager.startListening()
    }
}
