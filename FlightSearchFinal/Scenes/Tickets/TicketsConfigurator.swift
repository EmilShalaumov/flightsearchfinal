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
    
    init(service: TicketsServiceProtocol) {
        self.ticketService = service
    }
    
    func configure(view: TicketsViewController) {
        let presenter = TicketsPresenter(view: view, service: ticketService)
        
        view.presenter = presenter
    }
}
