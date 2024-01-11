//
//  PictureListViewModel.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 11/27/23.
//

import Foundation
import Combine

final class PictureListViewModel: ObservableObject {

    @Injected private var pictureRepository: PictureRepositoryProtocol

    @Published var state: State = .initial
    @Published var displayables: [PictureListDisplayable] = []

    init() {
        reload()
    }

    private func reload() {
        Task {
            Task { @MainActor in
                state = .loading
            }

            do {
                let pictures = try await pictureRepository.getPictures(startDate: K.startDate, endDate: nil)

                Task { @MainActor in
                    displayables = pictures.map { picture in
                        PictureListDisplayable(title: picture.title, imageUrl: picture.url, picture: picture)
                    }

                    state = .loaded
                }
            } catch let error as NetworkError {
                Task { @MainActor in
                    switch error {
                    case .badConfiguration:
                        state = .error(message: "Bad configuration.")
                    case .requestFailed(statusCode: let code):
                        state = .error(message: "Request failed (\(code))")
                    case .decoding:
                        state = .error(message: "Decoding error")
                    }
                }
            } catch {
                Task { @MainActor in
                    state = .error(message: error.localizedDescription)
                }
            }
        }
    }
}

extension PictureListViewModel {

    enum State {
        case initial
        case loading
        case loaded
        case error(message: String)
    }
}
