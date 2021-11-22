//
//  AllTrailsFoodTests.swift
//  AllTrailsFoodTests
//
//  Created by Steven G Pint on 11/17/21.
//

import XCTest
@testable import AllTrailsFood

class AllTrailsFoodTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuery1() {
        placesTextSearch("Pizza", locationText: nil)
    }

    func testQuery2() {
        placesTextSearch("Seafood in boston", locationText: nil)
    }

    func testQueryLocation1() {
        placesTextSearch("chinese", locationText: "37.33233141,-122.0312186")
    }

    func testQueryLocation2() {
        placesTextSearch("pizza", locationText: "37.33233141,-122.0312186")
    }

    func testQueryLocation3() {
        placesTextSearch("sandwiches", locationText: "")
    }

    func placesTextSearch(_ queryText: String, locationText: String?) {
        let exp = expectation(description: "Waiting for query to return and parse")
        let service = GooglePlacesService(query: queryText, location: locationText)
        service.load(completion: { response in
            switch response.result {
            case let .success(places):
                print("Count: \(places.count)")
            case let .failure(error):
                XCTFail("Timed out waiting for query: \(error)")
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10) {
            error in
            if let error = error {
                XCTFail("Timed out waiting for query: \(error)")
            }
        }
    }
}
