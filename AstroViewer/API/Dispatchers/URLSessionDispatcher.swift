//
//  URLSessionDispatcher.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

final class URLSessionDispatcher: NetworkDispatcher {

    func dispatch(requestData: RequestData) async throws -> Data {
        guard
            let url = requestData.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            throw NetworkError.badConfiguration
        }

        let queryItems = requestData.queryItems.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        urlComponents.queryItems = queryItems

        guard let urlWithQueryItems = urlComponents.url else {
            throw NetworkError.badConfiguration
        }

        var request = URLRequest(url: urlWithQueryItems)

        request.httpMethod = requestData.method.rawValue
        request.httpBody = requestData.body
        request.allHTTPHeaderFields = requestData.headers
        request.setValue(requestData.contentType, forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode != 200 {
                throw NetworkError.requestFailed(statusCode: statusCode)
            }
        }

        return data
    }

}
