//
//  PricingOption.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct PricingOption: Decodable {
    let price: Float
    
    enum CodingKeys: String, CodingKey {
        case price = "Price"
    }
}
