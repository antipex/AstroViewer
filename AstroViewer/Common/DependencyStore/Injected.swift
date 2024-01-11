//
//  Injected.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

@propertyWrapper
public final class Injected<T>: Sendable {

    public init() {}

    public var wrappedValue: T {
        let object: T = DependencyStore.shared.resolve()

        return object
    }

}
