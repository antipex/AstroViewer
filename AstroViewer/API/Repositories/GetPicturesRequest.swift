//
//  GetPicturesRequest.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

struct GetPicturesRequest: NasaRequest {

    typealias ResponseType = [Picture]

    let endpoint = "planetary/apod"
    let method: HTTPMethod = .get
    var queryItems: [String: String] = [:]

}

extension GetPicturesRequest {

    init(startDate: Date, endDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.dateFormat

        queryItems["start_date"] = dateFormatter.string(from: startDate)

        if let endDate {
            queryItems["end_date"] = dateFormatter.string(from: endDate)
        }
    }
}
