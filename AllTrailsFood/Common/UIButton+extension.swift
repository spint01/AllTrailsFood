//
//  UIButton+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/19/21.
//

import UIKit

extension UIButton {
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(top: contentPadding.top, left: contentPadding.left, bottom: contentPadding.bottom, right: contentPadding.right + imageTitlePadding)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageTitlePadding, bottom: 0, right: -imageTitlePadding)
    }
}
