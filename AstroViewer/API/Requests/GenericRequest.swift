//
//  GenericRequestProtocol.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol GenericRequest {

    associatedtype BodyType: Encodable
    associatedtype ResponseType: Decodable

    var url: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String] { get }
    var body: BodyType { get }
    var data: GenericRequestData { get }
}

extension GenericRequest {

    var data: GenericRequestData {
        GenericRequestData(
            url: url,
            method: method,
            queryItems: queryItems,
            body: method != .get ? body : nil
        )
    }

    @discardableResult func execute(
        dispatcher: NetworkDispatcher = URLSessionDispatcher()
    ) async throws -> ResponseType {
        let responseData = try await dispatcher.dispatch(requestData: data)
        let decoded = try JSONDecoder().decode(ResponseType.self, from: responseData)

        return decoded
    }
}
