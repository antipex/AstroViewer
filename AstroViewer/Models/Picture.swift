//
//  Picture.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Foundation

struct Picture: Codable {

    let title: String
    let explanation: String
    let copyright: String?

    let date: Date

    let url: URL
    let hdurl: URL

    enum CodingKeys: String, CodingKey {
        case title
        case explanation
        case copyright
        case date
        case url
        case hdurl
    }

}
