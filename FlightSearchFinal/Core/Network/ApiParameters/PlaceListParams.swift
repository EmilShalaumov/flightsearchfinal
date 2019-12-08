//
//  PlaceListParams.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class PlaceListParams: LocaleSettings {
    let queryString: String
    
    init(query string: String) {
        queryString = string
    }
}
