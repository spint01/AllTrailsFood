//
//  PlaceView.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/20/21.
//

import UIKit

final class PlaceView: UIView {

    private let photoImageView: UIImageView = .init()
    private let nameLabel: UILabel = .init()
    private let ratingLabel: UILabel = .init()
    private let totalReviewsLabel: UILabel = .init()
    private let detailLabel: UILabel = .init()
    private let verticalStackView: UIStackView = .init()

    private var isFavorite: Bool = false
    private var starFillImage: UIImage? = UIImage(systemName: "star.fill")
    private var starImage: UIImage? = UIImage(systemName: "star.fill")?.withTintColor(.lightGray, renderingMode: .alwaysTemplate)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: 70),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true

        verticalStackView.backgroundColor = .clear
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        verticalStackView.axis = .vertical

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8),
            verticalStackView.rightAnchor.constraint(equalTo: rightAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
        ])
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        nameLabel.textColor = .gray

        let secondRowStackView: UIStackView = .init()
        secondRowStackView.axis = .horizontal
        secondRowStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(secondRowStackView)

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
        secondRowStackView.addArrangedSubview(ratingLabel)
        totalReviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        secondRowStackView.addArrangedSubview(totalReviewsLabel)
        totalReviewsLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        totalReviewsLabel.textColor = .lightGray

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(detailLabel)
        detailLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        detailLabel.textColor = .gray
    }

    private func attachmentImage(_ image: UIImage) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        return NSAttributedString(attachment: attachment)
    }

    func configure(with viewModel: PlaceViewModel) {
        nameLabel.text = viewModel.name
        totalReviewsLabel.text = viewModel.totalRatings
        detailLabel.text = "\(viewModel.priceLevel)" //" * \(viewModel.detail)"

        if let starImage = starImage, let starFillImage = starFillImage {
            let attributedString = NSMutableAttributedString()
            for _ in 0..<viewModel.rating {
                attributedString.append(attachmentImage(starFillImage))
            }
            for _ in viewModel.rating..<5 {
                attributedString.append(attachmentImage(starImage))
            }
            ratingLabel.attributedText = attributedString
        }

        guard let photoURL = viewModel.photoURL else { return }
        // TODO: use SDWebImage
        DispatchQueue.global().async {
//            print("*** \(photoURL)")
            if let data = try? Data( contentsOf: photoURL) {
                DispatchQueue.main.async {
                    self.photoImageView.image = UIImage( data:data)
                }
            }
        }
    }
}
