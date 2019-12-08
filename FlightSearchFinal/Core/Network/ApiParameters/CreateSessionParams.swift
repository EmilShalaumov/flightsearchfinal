//
//  CreateSessionParams.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class CreateSessionParams: LocaleSettings {
    var originPlace: Airport?
    var destinationPlace: Airport?
    var outboundDate: Date?
    var inboundDate: Date?
    var adults: UInt = 1
}
