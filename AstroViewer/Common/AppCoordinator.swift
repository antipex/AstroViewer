//
//  AppCoordinator.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit

class AppCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()

    private let window: UIWindow
    private let injector: Injector

    init(window: UIWindow) {
        self.window = window
        self.injector = Injector()
    }

    func start() {
        let pictureListCoordinator = PictureListCoordinator(window: window, injector: injector)
        addChild(coordinator: pictureListCoordinator)
        pictureListCoordinator.start()
    }

}
