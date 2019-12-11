//
//  SearchPresenterTests.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import XCTest
@testable import FlightSearchFinal

class SearchPresenterTests: XCTestCase {
    var searchPresenter: SearchPresenter!
    var apiStub: FlightSearchAPIStub!
    var searchViewController: SearchViewControllerMock!

    override func setUp() {
        super.setUp()
    
        let router = SearchRouterStub()
        
        apiStub = FlightSearchAPIStub()
        searchViewController = SearchViewControllerMock()
        searchPresenter = SearchPresenter(view: searchViewController, router: router, api: apiStub)
    }

    override func tearDown() {
        super.tearDown()
        
        searchPresenter = nil
        apiStub = nil
    }
    
    func testThatPresenterRequestsToShowAlertWhenSessionKeyIsNil() {
        // assign
        apiStub.createSessionKey = nil
        
        // act
        searchPresenter.searchButtonTapped()
        
        // assert
        XCTAssertEqual(searchViewController.serverErrorAlertCallsCount, 1, "Show alert was not requested or requested more than one time.")
    }
}
