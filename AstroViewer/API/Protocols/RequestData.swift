//
//  RequestData.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol RequestData {

    var url: URL? { get }
    var method: HTTPMethod { get }

    var headers: [String: String] { get set }
    var queryItems: [String: String] { get set }
    var contentType: String { get }

    var body: Data? { get }

}
