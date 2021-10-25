//
//  Injector.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Foundation

class Injector {

    let pictureRepository: PictureRepositoryProtocol

    init() {
        self.pictureRepository = PictureRepository()
    }

}
