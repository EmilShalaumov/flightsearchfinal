//
//  Airport.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

struct Airport: Decodable {
    let placeId: String
    let placeName: String
    let countryId: String
    let regionId: String
    let cityId: String
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case placeId = "PlaceId"
        case placeName = "PlaceName"
        case countryId = "CountryId"
        case regionId = "RegionId"
        case cityId = "CityId"
        case countryName = "CountryName"
    }
}
