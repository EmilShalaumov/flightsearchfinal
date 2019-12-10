//
//  MOPricingOption.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 10.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import CoreData

internal class MOPricingOption: NSManagedObject {
    @NSManaged var price: Float
}

extension MOPricingOption {
    convenience init(data: PricingOption, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.price = data.price
    }
    
    var model: PricingOption {
        return PricingOption(price: self.price)
    }
}
