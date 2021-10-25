//
//  DiffableCollection.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Foundation

struct DiffableCollection<T>: Collection {
    enum ChangeType {
        case initial
        case added([Int])
        case removed([Int])
        case updated([Int])
    }

    private(set) var collection: [T]
    var changeType: ChangeType

    init(collection: [T] = [], changeType: ChangeType = .initial) {
        self.collection = collection
        self.changeType = changeType
    }

    var startIndex: Int {
        return collection.startIndex
    }
    var endIndex: Int {
        return collection.endIndex
    }

    func index(after index: Int) -> Int {
        return collection.index(after: index)
    }

    subscript(index: Int) -> T {
        get {
            return collection[index]
        }
        set {
            collection[index] = newValue
        }
    }
}
