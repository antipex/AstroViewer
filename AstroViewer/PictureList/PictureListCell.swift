//
//  PictureListCell.swift
//  AstroViewer
//
//  Created by Kyle Rohr on 24/10/21.
//

import UIKit

class PictureListCell: UITableViewCell {

    private let previewView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()

    private let titleLabel = UILabel()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        spinner.color = .lightGray
        return spinner
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = K.Spacing.single
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        previewView.image = nil
        titleLabel.text = nil
    }

    private func addSubviews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(previewView)
        stackView.addArrangedSubview(titleLabel)
        previewView.addSubview(spinner)

        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        stackView.apply(constraints: [
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            previewView.widthAnchor.constraint(equalToConstant: K.previewWidth),
        ])

        spinner.apply(constraints: [
            spinner.leftAnchor.constraint(equalTo: previewView.leftAnchor),
            spinner.rightAnchor.constraint(equalTo: previewView.rightAnchor),
            spinner.topAnchor.constraint(equalTo: previewView.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: previewView.bottomAnchor)
        ])
    }

    func configure(with displayable: PictureListDisplayable) {
        titleLabel.text = displayable.title

        if let image = displayable.image {
            previewView.image = image
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }

}
