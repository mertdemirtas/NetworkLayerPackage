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
    private let queue = DispatchQueue(label: "Monitor")
        
    public func checkConnection(completion: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            if(path.status == .satisfied) {
                completion(.satisfied)
            }
            else {
                completion(.unsatisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
