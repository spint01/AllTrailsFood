//
//  Place.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import Foundation

public struct Place: Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case address = "formatted_address"
        case geometry
        case name
        case photos
        case priceLevel = "price_level"
        case rating
        case totalRatings = "user_ratings_total"
    }

    public let id: String?
    public let address: String?
    public let geometry: PlaceGeometry?
    public let name: String?
    public let photos: [PlacePhoto]?
    public let priceLevel: Int?
    public let rating: Double?
    public let totalRatings: Int?
}

public struct PlaceGeometry: Codable {
    private enum CodingKeys: String, CodingKey {
        case location
    }

    public let location: PlaceLocation?
}

public struct PlaceLocation: Codable {
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }

    public let latitude: Double?
    public let longitude: Double?
}

public struct PlacePhoto: Codable {
    private enum CodingKeys: String, CodingKey {
        case height
        case width
        case reference = "photo_reference"
    }

    public let height: Double?
    public let width: Double?
    public let reference: String?
}
