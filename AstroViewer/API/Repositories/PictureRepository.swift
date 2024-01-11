//
//  PictureRepository.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

protocol PictureRepositoryProtocol {

    func getPictures(startDate: Date, endDate: Date?) async throws -> [Picture]
}

final class PictureRepository: PictureRepositoryProtocol, Injectable {

    let remoteSource: PictureRemoteSourceProtocol

    init(remoteSource: PictureRemoteSourceProtocol = PictureRemoteSource()) {
        self.remoteSource = remoteSource
    }

    func getPictures(startDate: Date, endDate: Date?) async throws -> [Picture] {
        return try await remoteSource.getPictures(startDate: startDate, endDate: endDate)
    }
}
