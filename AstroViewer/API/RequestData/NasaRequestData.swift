//
//  NasaRequestData.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

struct NasaRequestData: RequestData {

    let url: URL?
    let method: HTTPMethod

    var headers: [String: String] = [:]
    var queryItems: [String: String] = [:]
    let contentType = "application/json"

    var body: Data?
}

extension NasaRequestData {

    init(
        endpoint: String,
        method: HTTPMethod,
        queryItems: [String: String],
        apiKey: String?
    ) {
        if
            let url = URL(string: K.baseUrl)
        {
            self.url = url.appendingPathComponent(endpoint)
        } else {
            self.url = nil
        }

        self.method = method
        self.queryItems = queryItems

        if let apiKey {
            self.queryItems["api_key"] = apiKey
        }
    }
}
