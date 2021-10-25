//
//  PictureListCoordinator.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit
import Combine

class PictureListCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()

    private let window: UIWindow
    private let injector: Injector
    private var navigationController: UINavigationController?

    private let pictureRepository: PictureRepositoryProtocol

    private var cancellables = CancellablesDictionary()

    init(window: UIWindow, injector: Injector) {
        self.window = window
        self.injector = injector

        self.pictureRepository = injector.pictureRepository
    }

    func start() {
        showPictureListViewController()
    }

    private func showPictureListViewController() {
        let viewModel = PictureListViewModel(pictureRepository: pictureRepository)
        let viewController = PictureListViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)

        let callbackKey = AnyCancellable.getKey()
        viewModel.coordinatorCallback.sink { [weak self] callback in
            guard let self = self else { return }

            switch callback {
            case .navigateToPicture(let picture):
                self.showPictureDetailViewController(for: picture)
            }
        }.store(in: &cancellables, for: callbackKey)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showPictureDetailViewController(for picture: Picture) {
        let viewModel = PictureDetailViewModel(picture: picture)
        let viewController = PictureDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
