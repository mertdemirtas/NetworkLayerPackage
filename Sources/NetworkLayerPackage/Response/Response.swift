//
//  Response.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 20.04.2022.
//

import Foundation

open class Response {
    public var networkConstants : NetworkConstants
    public var httpMethod: HTTPMethods
    public var path: [String]?
    public var headers: [String: String]?
    public var body: [String: Any]?
    
    public init(networkConstants: NetworkConstants, httpMethod: HTTPMethods) {
        self.networkConstants = networkConstants
        self.httpMethod = httpMethod
    }
}

extension Response {
    // a default extension that creates the full URL
    var urlString: String {
        if let path = path, !(path.isEmpty) {
            var temp = ""
            for element in path {
                temp += element
            }
            return networkConstants.baseUrl + temp
        }
        
        else {
            return networkConstants.baseUrl
        }
    }
}
