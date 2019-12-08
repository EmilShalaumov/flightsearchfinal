//
//  Carrier.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct Carrier: ObjectWithId {
    let id: UInt
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case imageUrl = "ImageUrl"
    }
}
