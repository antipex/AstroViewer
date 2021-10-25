//
//  Coordinator.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {

    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(coordinator: Coordinator) {
        coordinator.removeAllChildren()
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func removeAllChildren() {
        childCoordinators.forEach { $0.removeAllChildren() }
        childCoordinators.removeAll()
    }

}
