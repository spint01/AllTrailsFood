//
//  PlaceAnnotation.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/20/21.
//

import UIKit
import MapKit

final class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var viewModel: PlaceViewModel

    init(coordinate: CLLocationCoordinate2D, viewModel: PlaceViewModel) {
        self.coordinate = coordinate
        self.viewModel = viewModel

        super.init()
    }
}
