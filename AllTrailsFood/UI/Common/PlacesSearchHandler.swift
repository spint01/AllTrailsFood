//
//  PlacesSearchHandler.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/19/21.
//

import Foundation

typealias QueryCompletion = (_ results: [Place]?, _ error: Error?) -> Void

final class PlacesSearchHandler {
    private let queryText: String
    private let locationText: String?

    init(queryText: String, locationText: String?) {
        self.queryText = queryText
        self.locationText = locationText
    }

    func performQuery(completion: @escaping QueryCompletion) {
        let service = GooglePlacesService(query: queryText, location: locationText)
        service.load(completion: { response in
            switch response.result {
            case let .success(places):
                completion(places, nil)
            case let .failure(error):
                completion(nil, error)
            }
        })
    }
}
