//
//  PictureListDisplayable.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

struct PictureListDisplayable: Identifiable {

    let id = UUID().uuidString

    let title: String
    var imageUrl: URL?

    let picture: Picture

}
