//
//  UICollectionView+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/18/21.
//

import UIKit

extension UICollectionView {
    func registerCellClass<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("UICollectionViewCell with identifier not registered: \(identifier)")
        }
        return cell
    }
}
