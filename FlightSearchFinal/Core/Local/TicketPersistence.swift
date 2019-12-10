//
//  TicketPersistence.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 10.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import CoreData

protocol TicketPersistenceProtocol {
    func saveTicket(entities: AllEntities, index: Int, completion: @escaping(Bool) -> Void)
}

class TicketPersistence: TicketPersistenceProtocol, TicketsServiceProtocol {
    private let stack = CoreDataStack()
    
    /// Save ticket into memory
    ///
    /// - Parameters:
    ///   - entities: AllEntities structure
    ///   - index: ticket index
    ///   - completion: Returns true if ticket was successfully saved, otherwise returns false
    func saveTicket(entities: AllEntities, index: Int, completion: @escaping(Bool) -> Void) {
        let itinerary = entities.itineraries[index]
        stack.persistentContainer.performBackgroundTask { context in
            let moItinerary = MOItinerary(data: itinerary, context: context)
            var optionSet = Set<MOPricingOption>()
            
            for option in itinerary.pricingOptions {
                let moPricingOption = MOPricingOption(data: option, context: context)
                optionSet.insert(moPricingOption)
            }
            
            moItinerary.pricingOptions = optionSet
            
            if let leg = entities.legs[itinerary.outboundLegId] {
                _ = MOLeg(data: leg, context: context)
                
                if let station = entities.places[leg.originStation] {
                    _ = MOPlace(data: station, context: context)
                }
                
                if let station = entities.places[leg.destinationStation] {
                    _ = MOPlace(data: station, context: context)
                }
            }
            
            if let inbound = itinerary.inboundLegId, let leg = entities.legs[inbound] {
                _ = MOLeg(data: leg, context: context)
                
                if let station = entities.places[leg.originStation] {
                    _ = MOPlace(data: station, context: context)
                }
                
                if let station = entities.places[leg.destinationStation] {
                    _ = MOPlace(data: station, context: context)
                }
            }

            do {
                try context.save()
                completion(true)
            } catch {
                let nserror = error as NSError
                print("Error saving itinerary \(nserror), \(nserror.userInfo)")
                completion(false)
            }
        }
    }
    
    /// Fetches all tickets stored in memory
    ///
    /// - Parameter completion: returns AllEntities structure with populated parameters
    func getTickets(completion: @escaping (AllEntities?) -> Void) {
        stack.persistentContainer.performBackgroundTask { context in
            var entities = AllEntities()
            let itinerariesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Itinerary")
            let legsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Leg")
            let placesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
            
            guard let itineraries = try? context.fetch(itinerariesRequest) as? [MOItinerary] else {
                completion(nil)
                return
            }
            
            guard let legs = try? context.fetch(legsRequest) as? [MOLeg] else {
                completion(nil)
                return
            }
            
            guard let places = try? context.fetch(placesRequest) as? [MOPlace] else {
                completion(nil)
                return
            }
            
            entities.itineraries = itineraries.map { $0.model }
            for leg in legs {
                entities.legs[leg.id] = leg.model
            }
            for place in places {
                entities.places[place.id] = place.model
            }
            completion(entities)
        }
    }
}
