//
//  PlaceCollectionViewCell.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/18/21.
//

import UIKit

final class PlaceCollectionViewCell: UICollectionViewCell {

    enum Constant {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
    }
    private let placeView: PlaceView = .init()
    private var place: Place?
    private let favoriteButton: UIButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO:
//        placeView.photoImageView.image = nil
    }

    private func commonInit() {
        backgroundColor = .clear
        contentView.layer.borderColor = UIColor.atGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white

        placeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(placeView)
        NSLayoutConstraint.activate([
            placeView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constant.horizontalPadding),
            placeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.verticalPadding),
            placeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.verticalPadding),
        ])

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.heightAnchor.constraint(equalToConstant: 25),
            favoriteButton.widthAnchor.constraint(equalToConstant: 25),
            favoriteButton.leftAnchor.constraint(equalTo: placeView.rightAnchor, constant: Constant.horizontalPadding),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constant.horizontalPadding),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.horizontalPadding),
        ])
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    @objc private func favoriteButtonTapped() {
        guard let place = place, let id = place.id else { return }
        var isFavorite = false
        if MainContainerViewController.favoritePlaces.contains(id) {
            MainContainerViewController.favoritePlaces.remove(id)
        } else {
            MainContainerViewController.favoritePlaces.insert(id)
            isFavorite = true
        }
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }

    private func attachmentImage(_ image: UIImage) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        return NSAttributedString(attachment: attachment)
    }

    func configure(with viewModel: PlaceViewModel) {
        place = viewModel.place
        placeView.configure(with: viewModel)
    }
}