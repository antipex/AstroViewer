//
//  NasaRequest.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol NasaRequest {

    associatedtype ResponseType: Decodable

    var endpoint: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String] { get }
}

extension NasaRequest {

    var data: NasaRequestData {
        NasaRequestData(
            endpoint: endpoint,
            method: method,
            queryItems: queryItems,
            apiKey: K.apiKey
        )
    }

    @discardableResult func execute(
        dispatcher: NetworkDispatcher = URLSessionDispatcher()
    ) async throws -> ResponseType {
        do {
            let responseData = try await dispatcher.dispatch(requestData: data)
            let decoded = try JSONDecoder().decode(ResponseType.self, from: responseData)

            return decoded
        } catch {
            throw NetworkError.decoding
        }
    }
}
