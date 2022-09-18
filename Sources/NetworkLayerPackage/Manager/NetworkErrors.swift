//
//  HTTPStatus.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 31.08.2022.
//

import Foundation

enum NetworkErrors: Error {
    case clientError
    case serverError
    case decodeError
    case unknown
    
    init(statusCode: Int) {
        switch(statusCode) {
        case 400...499:
            self = .clientError
        case 500...599:
            self = .serverError
        default:
            self = .unknown
        }
    }
}
