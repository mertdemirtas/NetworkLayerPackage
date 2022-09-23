//
//  ClientErrors.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public enum ClientErrors: String {
    case badRequest = "Bad Request"
    case unAuthorized = "UnAuthorized"
    case paymentRequired = "Payment Required"
    case forbidden = "Forbidden"
    case notFound = "Not Found"
    case methodNotAllowed = "Method Not Allowed"
    case notAcceptable = "Not Acceptable"
    case proxyAuthenticationRequired = "Proxy Authentication Required"
    case requestTimeout = "Request Timeout"
    case payloadTooLarge = "Payload Too Large"
    case unknown = "Unknown Client Error"
    
    init(statusCode: Int) {
        switch(statusCode) {
        case 400:
            self = .badRequest
        case 401:
            self = .unAuthorized
        case 402:
            self = .paymentRequired
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 406:
            self = .notAcceptable
        case 407:
            self = .proxyAuthenticationRequired
        case 408:
            self = .requestTimeout
        case 413:
            self = .payloadTooLarge
        default:
            self = .unknown
        }
    }
}
