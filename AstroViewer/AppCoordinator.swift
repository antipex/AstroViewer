//
//  AppCoordinator.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/28/23.
//

import Foundation
import SwiftUI

final class AppCoordinator: Coordinator, ObservableObject {

    var childCoordinators: [Coordinator] = []

    @Published var rootView: RootView = .pictureList

    private var navigationController: UINavigationController?

    init() {
        DependencyStore.shared.register(PictureRepository(), for: PictureRepositoryProtocol.self)
    }

    func start() {

    }

    func pictureListView() -> some View {
        let viewModel = PictureListViewModel()
        let view = PictureListView(viewModel: viewModel)

        return view
    }

    func pictureDetailView(for picture: Picture) -> some View {
        let viewModel = PictureDetailViewModel(picture: picture)
        let view = PictureDetailView(viewModel: viewModel)

        return view
    }
}

extension AppCoordinator {

    enum RootView {
        case pictureList
    }
}
