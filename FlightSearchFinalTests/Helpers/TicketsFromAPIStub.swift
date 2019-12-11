//
//  TicketsFromAPIStub.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
@testable import FlightSearchFinal

class TicketsFromAPIStub: TicketsServiceProtocol {
    
    func getTickets(completion: @escaping (AllEntities?) -> Void) {
        var entities = AllEntities()
        
        let option = PricingOption(price: 0)
        entities.itineraries = [Itinerary(outboundLegId: "0", inboundLegId: nil, pricingOptions: [option])]
        entities.legs = ["0": Leg(id: "0", originStation: 0, destinationStation: 0, departure: Date(), arrival: Date(), duration: 117, stops: [], carriers: [])]
        completion(entities)
    }
}
