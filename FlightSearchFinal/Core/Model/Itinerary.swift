//
//  Itinerary.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct Itinerary: Decodable {
    let outboundLegId: String
    let inboundLegId: String?
    let pricingOptions: [PricingOption]
    
    enum CodingKeys: String, CodingKey {
        case outboundLegId = "OutboundLegId"
        case inboundLegId = "InboundLegId"
        case pricingOptions = "PricingOptions"
    }
}
