//
//  NetworkConstants.swift
//  MovieApp-Invio
//
//  Created by Mert Demirtaş on 27.06.2022.
//

import Foundation

public protocol NetworkConstants {
    var apiKey: String? { get }
    var baseUrl: String { get }
}
