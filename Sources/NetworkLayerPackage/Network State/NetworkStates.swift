//
//  NetworkStates.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 16.09.2022.
//

import Foundation

public enum NetworkStates {
    case processing
    case done
    case error(NetworkErrors)
}
