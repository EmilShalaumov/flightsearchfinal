//
//  Leg.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct Leg: Decodable {
    let id: String
    let originStation: UInt
    let destinationStation: UInt
    let departure: Date
    let arrival: Date
    let duration: UInt
    let stops: [UInt]
    let carriers: [UInt]
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case originStation = "OriginStation"
        case destinationStation = "DestinationStation"
        case departure = "Departure"
        case arrival = "Arrival"
        case duration = "Duration"
        case stops = "Stops"
        case carriers = "Carriers"
    }
}
