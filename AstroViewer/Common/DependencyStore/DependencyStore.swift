//
//  DependencyStore.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation

public protocol Injectable {}

public final class DependencyStore {

    public static let shared = DependencyStore()

    private var store: [String: Dependency<Any>] = [:]
    private let storeQueue: DispatchQueue = DispatchQueue(label: K.dependencyStoreQueueLabel, attributes: .concurrent)

    public func register<T: Injectable, U>(_ initializer: @escaping @autoclosure () -> T, for type: U.Type) {
        let key = identifier(for: U.self)

        storeQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            if store.keys.contains(key) {
                fatalError("Attempted to register \(key) twice.")
            }

            store[key] = Dependency(initializer: initializer)
        }
    }

    public func resolve<T>() -> T {
        var dependency: Dependency<Any>?
        let key = identifier(for: T.self)

        storeQueue.sync {
            dependency = store[key]
        }

        guard let dependency else {
            fatalError("Could not resolve for \(T.self)")
        }

        if let value = dependency.value as? T {
            return value
        } else if let value = dependency.initializer() as? T {
            storeDependency(value, forKey: key)

            return value
        } else {
            // Never happens due to the register function being generic - this is needed only because `store.value` is `Any`
            fatalError("Could not cast \(String(describing: dependency.initializer)) to \(T.self)")
        }
    }

    private func storeDependency<T>(_ dependency: T, forKey key: String) {
        storeQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            store[key]?.value = dependency
        }
    }

    private func identifier<T>(for protocol: T) -> String {
        String(describing: T.self)
    }

}

private extension DependencyStore {

    struct Dependency<T> {

        let initializer: () -> Any
        var value: T?

    }

}
