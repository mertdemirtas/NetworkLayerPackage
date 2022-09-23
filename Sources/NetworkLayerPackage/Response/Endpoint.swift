//
//  Response.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 20.04.2022.
//

import Foundation

open class Endpoint {
    private var networkConstants : NetworkConstants
    private var httpMethod: HTTPMethods
    private var path: String?
    private var headers: [String: String]?
    private var body: [String: Any]?
    
    public init(networkConstants: NetworkConstants, httpMethod: HTTPMethods, path: String? = nil, headers: [String:String]? = nil, body: [String: Any]? = nil) {
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
