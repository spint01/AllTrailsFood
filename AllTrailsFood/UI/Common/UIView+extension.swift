//
//  UIView+extension.swift
//  AllTrailsFood
//
//  Created by Steve Pint on 7/25/22.
//

import UIKit

extension UIView {
    var isHorizontalSizeClassRegular: Bool {
        return traitCollection.horizontalSizeClass == .regular
    }
    
    // part of second feature
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

}
