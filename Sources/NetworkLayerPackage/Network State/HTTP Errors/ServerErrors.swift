//
//  ServerErrors.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public enum ServerErrors: String, Error {
    case internalServerError = "Internal Server Error"
    case notImplementet = "Not Implemented"
    case badGateway = "Bad Gateway"
    case serviceUnavailable = "Service UnAvailable"
    case gatewayTimeout = "Gateway Timeout"
    case notExtended = "Not Extended"
    case networkAuthenticationRequired = "Network Authentication Required"
    case unknown = "Unknown Server Error"
    
    init(statusCode: Int) {
        switch(statusCode) {
        case 500:
            self = .internalServerError
        case 501:
            self = .notImplementet
        case 502:
            self = .badGateway
        case 503:
            self = .serviceUnavailable
        case 504:
            self = .gatewayTimeout
        case 510:
            self = .notExtended
        case 511:
            self = .networkAuthenticationRequired
        default:
            self = .unknown
        }
    }
}
