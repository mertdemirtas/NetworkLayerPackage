//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 23.09.2022.
//

import Foundation
import Network
import Combine

@available(iOS 13.0, *)
public class NetworkConnection {
    
    private let monitor = NWPathMonitor()
    public let queue = DispatchQueue(label: "Monitor")
    
    var connectionStatus: Bool = false
    
    func checkConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            if(path.status == .satisfied) {
                self?.connectionStatus = true
            }
            else {
                self?.connectionStatus = false
            }
        }
        monitor.start(queue: queue)
    }
}
