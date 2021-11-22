//
//  UIViewController+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/18/21.
//

import UIKit

extension UIViewController {
    func addChildController(_ child: UIViewController, toView view: UIView) {
        self.addChild(child)
        child.view.frame = view.bounds
        child.view.insertAndPinToParentView(view)
        child.didMove(toParent: self)
    }

    func removeFromParentController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
