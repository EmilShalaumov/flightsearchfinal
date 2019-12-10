//
//  MOLeg.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 10.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import CoreData

internal class MOLeg: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var originStation: UInt
    @NSManaged var destinationStation: UInt
    @NSManaged var departure: Date
    @NSManaged var arrival: Date
    @NSManaged var duration: UInt
    @NSManaged var stops: [UInt]
}

extension MOLeg {
    convenience init(data: Leg, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = data.id
        self.originStation = data.originStation
        self.destinationStation = data.destinationStation
        self.departure = data.departure
        self.arrival = data.arrival
        self.duration = data.duration
        self.stops = data.stops
    }
    
    var model: Leg {
        return Leg(id: id,
                   originStation: originStation,
                   destinationStation: destinationStation,
                   departure: departure,
                   arrival: arrival,
                   duration: duration,
                   stops: stops,
                   carriers: [])
    }
}
