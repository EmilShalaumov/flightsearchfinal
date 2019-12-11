//
//  SearchRouterStub.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
@testable import FlightSearchFinal

class SearchRouterStub: SearchRouterProtocol {
    func presentSearchAirport(delegate: SearchAirportPresenterDelegate, img: String, tag: Int) {
        return
    }
    
    func presentTickets(with key: String) {
        return
    }
}
