//
//  PictureListViewModel.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import Combine
import UIKit

class PictureListViewModel: ObservableObject {

    @Published private(set) var state: State = .initial("Astronomy Picture of the Day", K.startDate)

    private var pictures = [Picture]()
    private var displayables = [PictureListDisplayable]()

    let pictureRepository: PictureRepositoryProtocol

    var viewEvents = PassthroughSubject<ViewEvent, Never>()

    var coordinatorCallback: AnyPublisher<CoordinatorCallback, Never> {
        coordinatorCallbackPipe.eraseToAnyPublisher()
    }
    private let coordinatorCallbackPipe = PassthroughSubject<CoordinatorCallback, Never>()

    private var cancellables = CancellablesDictionary()

    init(pictureRepository: PictureRepositoryProtocol) {
        self.pictureRepository = pictureRepository

        let viewEventsKey = AnyCancellable.getKey()
        viewEvents.sink { [weak self] viewEvent in
            guard let self = self else { return }

            self.handleViewEvent(viewEvent)
        }.store(in: &cancellables, for: viewEventsKey)
    }

    private func handleViewEvent(_ viewEvent: ViewEvent) {
        switch viewEvent {
        case .load:
            loadPictures()
        case .tappedPhoto(let indexPath):
            coordinatorCallbackPipe.send(.navigateToPicture(pictures[indexPath.row]))
        }
    }

    private func loadPictures() {
        state = .loading

        let pictureKey = AnyCancellable.getKey()
        pictureRepository.getPictures(startDate: K.startDate, endDate: nil).sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.state = .error(error)
            }
        } receiveValue: { [weak self] result in
            guard let self = self else { return }

            self.pictures = result.sorted(by: { $0.date.compare($1.date) == .orderedDescending })

            let displayables = result.map { picture in
                PictureListDisplayable(title: picture.title, image: nil)
            }
            self.displayables = displayables

            self.state = .loaded(DiffableCollection<PictureListDisplayable>(collection: displayables, changeType: .initial))

            let previews = result.enumerated().map { (index, picture) in
                (url: picture.url, index: index)
            }
            self.loadImagePreviews(from: previews)
        }.store(in: &cancellables, for: pictureKey)
    }

    private func loadImagePreviews(from previews: [(url: URL, index: Int)]) {
        for picture in previews {
            let dataTaskKey = AnyCancellable.getKey()
            URLSession.shared.dataTaskPublisher(for: picture.url).sink { completion in

            } receiveValue: { [weak self] (data: Data, response: URLResponse) in
                guard let self = self else { return }

                if let image = UIImage(data: data) {
                    self.displayables[picture.index].image = image

                    let changeType = DiffableCollection<PictureListDisplayable>.ChangeType.updated([picture.index])
                    let collection = DiffableCollection<PictureListDisplayable>(collection: self.displayables, changeType: changeType)

                    DispatchQueue.main.async {
                        self.state = .loaded(collection)
                    }
                } else {
                    // Handle error
                }
            }.store(in: &cancellables, for: dataTaskKey)
        }
    }

}

extension PictureListViewModel {

    enum State {
        case initial(String, Date)
        case loading
        case loaded(DiffableCollection<PictureListDisplayable>)
        case error(Error)
    }

    enum ViewEvent {
        case load
        case tappedPhoto(IndexPath)
    }

    enum CoordinatorCallback {
        case navigateToPicture(Picture)
    }

}
