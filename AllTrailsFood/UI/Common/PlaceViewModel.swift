//
//  PlaceViewModel.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/20/21.
//

import Foundation
import CoreLocation

protocol PlaceModelDisplayable {
    var name: String { get }
    var photoURL: URL? { get }
    var rating: Int { get }
    var totalRatings: String { get }
    var priceLevel: String  { get }
    var detail: String  { get }
    var locationCoordinate: CLLocationCoordinate2D? { get }
}

struct PlaceViewModel: PlaceModelDisplayable {
    let place: Place
    var detail: String {
        return ""
    }
    var photoURL: URL? {
        return place.photoURL
    }
    var rating: Int {
        guard let rating = place.rating.flatMap({ Int(round($0)) }) else { return 0 }
        return max(min(5, rating), 0)
    }
    var totalRatings: String {
        guard let totalRatings = place.totalRatings, totalRatings >= 0 else { return "" }
        return "(\(totalRatings))"
    }
    var priceLevel: String {
        guard let priceLevel = place.priceLevel else { return " " }
        let level = max(min(5, priceLevel), 0)
        return String(repeating: "$", count: Int(level))
    }
    var name: String {
        return place.name ?? "No Name Found"
    }
    var locationCoordinate: CLLocationCoordinate2D? {
        return place.locationCoordinate
    }
}
