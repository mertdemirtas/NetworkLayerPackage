//
//  File.swift
//  
//
//  Created by Mert Demirtaş on 20.09.2022.
//

import Foundation

public class GenericResponse<ResponseType: Codable> {
    private var response: ResponseType?
    private var networkError: NetworkErrors?
    
    init(response: ResponseType? = nil, networkError: NetworkErrors? = nil) {
        self.response = response
        self.networkError = networkError
    }
}
