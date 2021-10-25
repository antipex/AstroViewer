//
//  PictureDetailViewController.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit
import Combine

class PictureDetailViewController: UIViewController {

    private let viewModel: PictureDetailViewModel

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()

    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = K.Spacing.single
        return stackView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        return spinner
    }()

    private var cancellables = CancellablesDictionary()

    init(viewModel: PictureDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        addSubviews()
        setupConstraints()
        addViewModelBindings()

        viewModel.viewEvents.send(.viewDidLoad)
    }

    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(spinner)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(copyrightLabel)
    }

    private func setupConstraints() {
        imageView.apply(constraints: [
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        stackView.apply(constraints: [
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: K.Spacing.single),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -K.Spacing.single),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
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
                case .initial:
                    break
                case .loading(let title):
                    self.title = title
                    self.spinner.startAnimating()
                case .loaded(let displayable):
                    self.configure(with: displayable)
                    self.spinner.stopAnimating()
                case .error(_):
                    self.spinner.stopAnimating()
                }
            }
        }.store(in: &cancellables, for: stateKey)
    }

    private func configure(with displayable: PictureDetailDisplayable) {
        imageView.image = displayable.image
        detailLabel.text = displayable.detail
        dateLabel.text = displayable.dateString
        copyrightLabel.text = displayable.copyright
    }

}
