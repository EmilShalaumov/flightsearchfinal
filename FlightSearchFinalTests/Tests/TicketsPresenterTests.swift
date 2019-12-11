//
//  TicketsPresenterTests.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import XCTest
@testable import FlightSearchFinal

class TicketsPresenterTests: XCTestCase {
    var ticketsPresenter: TicketsPresenter!

    override func setUp() {
        super.setUp()
        
        let viewControllerStub = TicketsViewControllerStub()
        let serviceStub = TicketsFromAPIStub()
        ticketsPresenter = TicketsPresenter(view: viewControllerStub, service: serviceStub)
    }

    override func tearDown() {
        super.tearDown()
        
        ticketsPresenter = nil
    }
    
    func testDurationFieldGetsCorrectValueInHoursAndMinutes() {
        // assign
        let ticketCell = TicketCell()
        ticketsPresenter.loadTickets()
        
        // act
        ticketsPresenter.configureCell(ticketCell, index: 0)
        
        // assert
        let result = ticketCell.outbound.duration.text
        XCTAssertEqual(result, "1 hours 57 minutes duration", "Duration field was not correctly glued")
    }
}
