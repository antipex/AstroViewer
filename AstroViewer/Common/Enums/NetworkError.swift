//
//  NetworkError.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

enum NetworkError: Error {
    
    case badConfiguration
    case requestFailed(statusCode: Int)
    case decoding
}
