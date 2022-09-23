//
//  Response.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 20.04.2022.
//

import Foundation

public protocol Endpoint {
    var networkConstants : NetworkConstants { get }
    var httpMethod: HTTPMethods { get }
    var path: String? { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
    
}

extension Endpoint {
    // a default extension that creates the full URL
    var urlString: String {
        guard let path = path else { return networkConstants.baseUrl }
        return networkConstants.baseUrl + path
    }
}
