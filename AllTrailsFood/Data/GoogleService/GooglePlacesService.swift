//
//  GooglePlacesService.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import UIKit

final public class GooglePlacesService: GoogleService<[Place]> {

    private let query: String
    private let location: String?

    init(query: String, location: String?) {
        self.query = query
        self.location = location
    }

    public override var urlString: String {
        return String(format: "%@/maps/api/place/textsearch/json", GooglePlaceEnvironment.urlString)
    }

    public override var parameters: [URLQueryItem] {
        var params: [URLQueryItem] = [
            URLQueryItem(name: "key", value: GooglePlaceEnvironment.key),
            URLQueryItem(name: "query", value: query),
        ]
        if let location = location {
            params.append(URLQueryItem(name: "location", value: location))
        }
        return params
    }

    override public var parse: (Data) throws -> Result<[Place], Error> {
        return { (data: Data) -> Result<[Place], Error> in
            let placesContainer = try self.jsonDecoder.decode(PlaceContainer.self, from: data)
            guard let status = placesContainer.status, status.caseInsensitiveCompare("ok") == .orderedSame, let places = placesContainer.places else {
                return Result.failure(WebServiceError.noData)
            }
            return Result.success(places)
        }
    }
}

private struct PlaceContainer: Codable {
    private enum CodingKeys: String, CodingKey {
        case places = "results"
        case status
    }

    let places: [Place]?
    let status: String?
}
