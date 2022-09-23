//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public class NetworkModel: Error {
    private var statusCode: Int
    private var statusDescription: NetworkErrorsType
    
    init(statusCode: Int, statusDescription: NetworkErrorsType) {
        self.statusCode = statusCode
        self.statusDescription = statusDescription
    }
}
