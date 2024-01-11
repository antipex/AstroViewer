//
//  AstroViewerApp.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import SwiftUI

@main
struct AstroViewerApp: App {

    @StateObject var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            switch appCoordinator.rootView {
            case .pictureList:
                appCoordinator.pictureListView()
                    .environmentObject(appCoordinator)
            }
        }
    }
}
