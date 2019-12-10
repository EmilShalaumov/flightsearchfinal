//
//  MOPlace.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 10.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import CoreData

internal class MOPlace: NSManagedObject {
    @NSManaged var id: UInt
    @NSManaged var code: String
    @NSManaged var name: String
}

extension MOPlace {
    convenience init(data: Place, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = data.id
        self.code = data.code
        self.name = data.name
    }
    
    var model: Place {
        return Place(id: id, code: code, name: name)
    }
}
