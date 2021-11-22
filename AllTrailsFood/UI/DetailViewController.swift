//
//  DetailViewController.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import UIKit

final class DetailViewController: UIViewController {

    enum Constant {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
    }

    private var placeView: PlaceView = .init()
    var viewModel: PlaceViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            placeView.configure(with: viewModel)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: setup

    private func setupUI() {
        view.backgroundColor = .atGray
        placeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeView)
        NSLayoutConstraint.activate([
            placeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constant.horizontalPadding),
            placeView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.verticalPadding),
        ])
    }
}
