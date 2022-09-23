//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public protocol RequestType {
    var requestModel: Codable { get set }
    var endpoint: Endpoint { get set }
}
