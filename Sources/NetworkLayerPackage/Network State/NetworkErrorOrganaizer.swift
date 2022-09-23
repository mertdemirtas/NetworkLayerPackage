//
//  NetworkErrors.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 31.08.2022.
//

import Foundation

public class NetworkErrorOrganaizer {
    public class func organize(statusCode: Int) -> HTTPErrors {
        return HTTPErrors.clientError(.forbidden)
    }
}
