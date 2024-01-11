//
//  GenericRequestData.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

struct GenericRequestData: RequestData {

    let url: URL?
    let method: HTTPMethod

    var headers: [String: String] = [:]
    var queryItems: [String: String] = [:]
    let contentType = "application/json"

    var body: Data?
}

extension GenericRequestData {

    init(
        url: String,
        method: HTTPMethod,
        queryItems: [String: String],
        body: Encodable?
    ) {
        if
            let url = URL(string: url)
        {
            self.url = url
        } else {
            self.url = nil
        }

        self.method = method
        self.queryItems = queryItems

        if let body = body {
            self.body = try? JSONEncoder().encode(body)
        }
    }
}
