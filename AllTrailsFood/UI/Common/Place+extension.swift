//
//  Place+extension.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/21/21.
//

import Foundation
import CoreLocation

extension Place {
    var photoURL: URL? {
        guard let placePhoto = photos?.first, let reference = placePhoto.reference else { return nil }
        let url = URL(string: "\(GooglePlaceEnvironment.photoBaseURL)?maxwidth=250&photo_reference=\(reference)&key=\(GooglePlaceEnvironment.key)")
        return url
    }
    
    var locationCoordinate: CLLocationCoordinate2D? {
        guard let location = geometry?.location, let latitude = location.latitude, let longitude = location.longitude else { return nil }
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
