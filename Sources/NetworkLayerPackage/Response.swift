//
//  Endpoint.swift
//  Taxi App
//
//  Created by Mert Demirtaş on 20.04.2022.
//

import Foundation

public protocol Response {
    var networkConstants : NetworkConstants { get }
    var httpMethod: HTTPMethods { get }
    var path: String? { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension Response {
    // a default extension that creates the full URL
    var urlString: String {
        guard let path = path else { return ""}
        return networkConstants.baseUrl + path
    }
}
