//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 23.09.2022.
//

import Foundation

public struct NetworkError: Error {
    public var error: NetworkErrorsType
    public var errorDescription: String
    
    init(error: NetworkErrorsType) {
        self.error = error
        self.errorDescription = error.localizedDescription
    }
}
