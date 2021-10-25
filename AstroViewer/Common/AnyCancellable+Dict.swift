//
//  AnyCancellable+Dict.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Foundation
import Combine

typealias CancellablesDictionary = Dictionary<UInt64, AnyCancellable>

// https://geekanddad.wordpress.com/2019/12/05/improving-on-the-common-anycancellable-store-pattern/

extension AnyCancellable {

    static func getKey() -> UInt64 {
        DispatchTime.now().uptimeNanoseconds
    }

    func store(in dictionary: inout [UInt64: AnyCancellable],
               for key: UInt64) {
        dictionary[key] = self
    }

}
