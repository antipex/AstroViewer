//
//  NetworkDispatcher.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol NetworkDispatcher {

    func dispatch(requestData: RequestData) async throws -> Data
}
