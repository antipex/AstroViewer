//
//  Constants.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit

struct K {

    static let apiKey = "ZqyLt1UUkz0RhaFHXfht11sRClkQn5MrALxLEQMn"
    static let baseUrl = "https://api.nasa.gov/planetary"

    static let dateFormat = "yyyy-MM-dd"
    static let longDateFormat = "d MMMM yyyy"

    static let startDate = Date().advanced(by: -518400)

    static let previewWidth: CGFloat = 64

    struct Spacing {
        static let half: CGFloat = 4
        static let single: CGFloat = 8
        static let double: CGFloat = 16
    }

}
