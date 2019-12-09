//
//  TicketsConfigurator.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class TicketsConfigurator {
    private let ticketService: TicketsServiceProtocol
    
    /// Initializes configurator with predefine get data service
    ///
    /// - Parameter service: The way to get data (from API or from local persistence)
    init(service: TicketsServiceProtocol) {
        self.ticketService = service
    }
    
    /// Configures tickets scene (view, presenter)
    ///
    /// - Parameter view: Tickets view controller
    func configure(view: TicketsViewController) {
        let presenter = TicketsPresenter(view: view, service: ticketService)
        
        view.presenter = presenter
    }
}
