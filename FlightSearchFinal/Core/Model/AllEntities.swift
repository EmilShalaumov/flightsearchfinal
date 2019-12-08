//
//  AllEntities.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct AllEntities {
    var places: [UInt: Place] = [:]
    var carriers: [UInt: Carrier] = [:]
    var legs: [String: Leg] = [:]
    var itineraries: [Itinerary] = []
}
