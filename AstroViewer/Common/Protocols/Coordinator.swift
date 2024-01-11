//
//  Coordinator.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/28/23.
//

import Foundation

protocol Coordinator: AnyObject {

    var childCoordinators: [Coordinator] { get set }

    func start()
}

extension Coordinator {

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        coordinator.removeAllChildren()
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func removeAllChildren() {
        childCoordinators.forEach { $0.removeAllChildren() }
        childCoordinators.removeAll()
    }
}
