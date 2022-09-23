//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 22.09.2022.
//

import Foundation

public enum NetworkErrors: Error {
    case httpError(HTTPErrors)
    case encodeError
    case unknown
}
