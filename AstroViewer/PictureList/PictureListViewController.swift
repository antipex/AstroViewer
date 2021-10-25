//
//  ViewController.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit
import Combine

class PictureListViewController: UITableViewController {

    private let viewModel: PictureListViewModel
    private var displayables = [PictureListDisplayable]()

    private var cancellables = CancellablesDictionary()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        return spinner
    }()

    private var startDate: Date?

    init(viewModel: PictureListViewModel) {
        self.viewModel = viewModel

        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PictureListCell.self, forCellReuseIdentifier: String(describing: PictureListCell.self))

        addSubviews()
        setupConstraints()
        addViewModelBindings()

        viewModel.viewEvents.send(.load)
    }

    private func addSubviews() {
        view.addSubview(spinner)
    }

    private func setupConstraints() {
        spinner.apply(constraints: [
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func addViewModelBindings() {
        let stateKey = AnyCancellable.getKey()
        viewModel.$state.sink { [weak self] state in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch state {
                case .initial(let title, let startDate):
                    self.title = title
                    self.startDate = startDate
                case .loading:
                    self.spinner.startAnimating()
                case .loaded(let collection):
                    self.spinner.stopAnimating()
                    self.displayables = collection.collection

                    switch collection.changeType {
                    case .initial:
                        self.tableView.reloadData()
                    case .updated(let indexes):
                        self.tableView.reloadRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    case .added(let indexes):
                        self.tableView.insertRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    case .removed(let indexes):
                        self.tableView.deleteRows(at: indexes.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    }

                    self.tableView.reloadData()
                case .error(let error):
                    self.spinner.stopAnimating()
                    print(error.localizedDescription)
                }
            }
        }.store(in: &cancellables, for: stateKey)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayables.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let startDate = startDate else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.longDateFormat

        return dateFormatter.string(from: startDate) + " to " + dateFormatter.string(from: Date())
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PictureListCell.self), for: indexPath) as? PictureListCell else { return UITableViewCell() }
        let displayable = displayables[indexPath.row]

        cell.configure(with: displayable)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.viewEvents.send(.tappedPhoto(indexPath))
    }

}

