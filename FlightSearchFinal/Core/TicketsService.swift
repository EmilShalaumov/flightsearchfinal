//
//  TicketsService.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol TicketsServiceProtocol {
    func getTickets(completion: @escaping(AllEntities?) -> Void)
}

class TicketsFromAPI: TicketsServiceProtocol {
    private let key: String
    private let api: FlightSearchAPIProtocol
    
    /// Initializes TicketsFromAPI service to get tickets from API
    ///
    /// - Parameter key: Session key
    init(key: String) {
        self.key = key
        
        let network = NetworkService()
        self.api = FlightSearchAPI(with: network)
    }
    
    /// Calls to get tickets from API
    ///
    /// - Parameter completion: Returns AllEntities structure with populated components
    func getTickets(completion: @escaping (AllEntities?) -> Void) {
        api.pollSessionResults(with: key) { tickets in
            completion(tickets)
        }
    }
}
