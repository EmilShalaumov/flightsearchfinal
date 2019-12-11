//
//  FlightSearchApiTests.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import XCTest
@testable import FlightSearchFinal

class FlightSearchApiTests: XCTestCase {
    var networkServiceStub: NetworkServiceStub!
    var flightSearchAPI: FlightSearchAPI!

    override func setUp() {
        super.setUp()
        
        networkServiceStub = NetworkServiceStub()
        flightSearchAPI = FlightSearchAPI(with: networkServiceStub)
    }

    override func tearDown() {
        super.tearDown()
        
        networkServiceStub = nil
        flightSearchAPI = nil
    }

    func testThatClassProcessesListOfFiveAirportsFromJSON() {
        // assign
        networkServiceStub.setSourceFile(name: "airports.json")
        
        // act
        flightSearchAPI.listPlaces(by: "Moscow") { airports in
            
            // assert
            XCTAssertEqual(airports.count, 5, "Airports count is not equal to expected result.")
        }
    }

    func testThatCreateSessionRequestExtractsSessionKeyFromLink() {
        // assign
        let key = "4caf6c60-d4b4-4a22-8125-4c372620bcc1"
        let link = "http://partners.api.skyscanner.net/apiservices/pricing/uk2/v1.0/" + key
        networkServiceStub.setResponseLink(link)
        let params = CreateSessionParams()
        
        // act
        flightSearchAPI.createSession(params: params) { sessionKey in
            
            // assert
            XCTAssertEqual(key, sessionKey, "Source key \(key) is not equal to extracted one.")
        }
        
    }
    
    func testThatPollSessionResultsIsParsedFromJSON() {
        // assign
        networkServiceStub.setSourceFile(name: "tickets.json")
        let key = "4caf6c60-d4b4-4a22-8125-4c372620bcc1"
        
        // act
        flightSearchAPI.pollSessionResults(with: key) { result in
            
            if let result = result {
                
                // assert
                var expected = 19
                XCTAssertEqual(result.places.count, expected, "Parsed amount of places (\(result.places.count)) is not equal to expected(\(expected))")
                
                expected = 8
                XCTAssertEqual(result.carriers.count, expected, "Parsed amount of carriers (\(result.carriers.count)) is not equal to expected(\(expected))")
                
                expected = 30
                XCTAssertEqual(result.legs.count, expected, "Parsed amount of legs (\(result.legs.count)) is not equal to expected(\(expected))")
                
                XCTAssertEqual(result.itineraries.count, expected, "Parsed amount of itineraries (\(result.itineraries.count)) is not equal to expected(\(expected))")
            }
        }
    }
}
