//
//  HTTPErrors.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public enum HTTPErrors {
    case clientError(ClientErrors)
    case serverError(ServerErrors)
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 400...499:
            self = .clientError(ClientErrors(statusCode: statusCode))
            break
            
        case 500...599:
            self = .serverError(ServerErrors(statusCode: statusCode))
            break
            
        default:
            self = .unknown
        }
    }
}
