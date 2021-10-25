//
//  PictureDetailViewModel.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Combine
import UIKit

class PictureDetailViewModel: ObservableObject {

    @Published private(set) var state: State = .initial

    private let picture: Picture

    var viewEvents = PassthroughSubject<ViewEvent, Never>()

    private var cancellables = CancellablesDictionary()

    init(picture: Picture) {
        self.picture = picture

        let viewEventKey = AnyCancellable.getKey()
        viewEvents.sink { [weak self] viewEvent in
            self?.loadPicture()
        }.store(in: &cancellables, for: viewEventKey)
    }

    private func handleViewEvent(_ viewEvent: ViewEvent) {
        switch viewEvent {
        case .viewDidLoad:
            loadPicture()
        }
    }

    private func loadPicture() {
        state = .loading(picture.title)

        let dataTaskKey = AnyCancellable.getKey()
        URLSession.shared.dataTaskPublisher(for: picture.hdurl).sink { completion in

        } receiveValue: { [weak self] (data: Data, response: URLResponse) in
            guard let self = self else { return }

            if let image = UIImage(data: data) {
                var copyright: String?

                if let possibleCopyright = self.picture.copyright {
                    copyright = "© " + possibleCopyright
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = K.longDateFormat

                let displayable = PictureDetailDisplayable(
                    title: self.picture.title,
                    detail: self.picture.explanation,
                    copyright: copyright,
                    image: image,
                    dateString: dateFormatter.string(from: self.picture.date)
                )

                self.state = .loaded(displayable)
            } else {
                // Handle error
            }
        }.store(in: &cancellables, for: dataTaskKey)
    }

}

extension PictureDetailViewModel {

    enum State {
        case initial
        case loading(String)
        case loaded(PictureDetailDisplayable)
        case error(Error)
    }

    enum ViewEvent {
        case viewDidLoad
    }

}
