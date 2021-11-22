//
//  OverlayView.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/18/21.
//

import UIKit

protocol OverlayViewDelegate: AnyObject {
    func buttonTapped()
}

final class OverlayView: UIView {
    private let button: UIButton = UIButton(type: .system)

    weak var delegate: OverlayViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.backgroundColor = .atGreen
        button.insertAndPinToParentView(self)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5), imageTitlePadding: 5)
    }

    @objc private func buttonTapped() {
        delegate?.buttonTapped()
    }

    func configure(with viewType: ViewType) {
        button.setTitle(viewType.overlayTitle, for: .normal)
        button.setImage(viewType.overlayImage, for: .normal)
    }
}

