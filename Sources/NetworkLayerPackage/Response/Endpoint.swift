//
//  Response.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 20.04.2022.
//

import Foundation

open class Endpoint {
    public var networkConstants : NetworkConstants
    public var httpMethod: HTTPMethods
    public var path: String?
    public var headers: [String: String]?
    public var body: [String: Any]?
    
    init(networkConstants: NetworkConstants, httpMethod: HTTPMethods, path: String? = nil, headers: [String:String]? = nil, body: [String: Any]? = nil) {
        self.networkConstants = networkConstants
        self.httpMethod = httpMethod
        self.path = path
        self.headers = headers
        self.body = body
    }
}

extension Endpoint {
    // a default extension that creates the full URL
    var urlString: String {
        guard let path = path else { return networkConstants.baseUrl }
        return networkConstants.baseUrl + path
    }
}
