//
//  MOItinerary.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 10.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import CoreData

internal class MOItinerary: NSManagedObject {
    @NSManaged var outboundLegId: String
    @NSManaged var inboundLegId: String?
    
    @NSManaged var pricingOptions: Set<MOPricingOption>
}

extension MOItinerary {
    convenience init(data: Itinerary, context: NSManagedObjectContext) {
        self.init(context: context)
        
        outboundLegId = data.outboundLegId
        inboundLegId = data.inboundLegId
    }
    
    var model: Itinerary {
        return Itinerary(outboundLegId: self.outboundLegId,
                         inboundLegId: self.inboundLegId,
                         pricingOptions: Array(pricingOptions.map { $0.model }))
    }
}
