//
//  PlaceAnnotationView.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/20/21.
//

import UIKit
import MapKit

final class PlaceAnnotationView: MKAnnotationView {

    enum Constant {
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 8
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        isDraggable = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with annotation: MKAnnotation) {
        guard let annotation = annotation as? PlaceAnnotation else { return }

        let placeView = PlaceView()
        placeView.configure(with: annotation.viewModel)
        let container: UIView = .init()
        placeView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(placeView)
        NSLayoutConstraint.activate([
            placeView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: Constant.horizontalPadding),
            placeView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -Constant.horizontalPadding),
            placeView.topAnchor.constraint(equalTo: container.topAnchor, constant: Constant.verticalPadding),
            placeView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constant.verticalPadding),
        ])
        detailCalloutAccessoryView = container

        guard let id = annotation.viewModel.place.id else { return }
        if MainContainerViewController.favoritePlaces.contains(id) {
            image = UIImage(systemName: "heart.fill")
        } else {
            image = UIImage(systemName: "drop.fill")
        }
    }
}
