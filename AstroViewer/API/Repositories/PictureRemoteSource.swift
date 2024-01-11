//
//  PictureRemoteSource.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol PictureRemoteSourceProtocol {

    func getPictures(startDate: Date, endDate: Date?) async throws -> [Picture]
}

final class PictureRemoteSource: PictureRemoteSourceProtocol {

    func getPictures(startDate: Date, endDate: Date?) async throws -> [Picture] {
        return try await GetPicturesRequest(
            startDate: startDate,
            endDate: endDate
        ).execute()
    }
}
