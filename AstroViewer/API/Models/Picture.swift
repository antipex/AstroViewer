//
//  Picture.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

struct Picture: Decodable {

    let title: String
    let explanation: String
    let copyright: String?

    let date: String

    let url: URL
    let hdurl: URL

}
