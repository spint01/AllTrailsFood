//
//  MapKit+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/21/21.
//

import Foundation
import MapKit

extension MKMapView {
    func registerAnnotationClass<T: MKAnnotationView>(_: T.Type) {
        register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableView<T: MKAnnotationView>(for annotation: MKAnnotation) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation) as? T else {
            fatalError("MKAnnotationView with identifier not registered: \(identifier)")
        }
        return cell
    }
}

