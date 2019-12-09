//
//  TicketsPresenter.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol TicketsPresenterProtocol {
    var ticketsCount: Int { get }
    func loadTickets()
    func configureCell(_ cell: TicketCell, index: Int)
}

class TicketsPresenter: TicketsPresenterProtocol {
    private weak var view: TicketsViewControllerProtocol?
    private let service: TicketsServiceProtocol
    
    private var entities = AllEntities()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var ticketsCount: Int {
        return entities.itineraries.count
    }
    
    init(view: TicketsViewControllerProtocol, service: TicketsServiceProtocol) {
        self.view = view
        self.service = service
    }
    
    // MARK: - Protocol methods
    
    func loadTickets() {
        service.getTickets { entities in
            self.entities = entities ?? AllEntities()
            self.view?.reloadTableViewData()
        }
    }
    
    func configureCell(_ cell: TicketCell, index: Int) {
        if 1 == 1 {
            let ticket = entities.itineraries[index]
            if let outbound = entities.legs[ticket.outboundLegId] {
                cell.outbound.departure.text = timeFormatter.string(from: outbound.departure)
                cell.outbound.arrival.text = timeFormatter.string(from: outbound.arrival)
                cell.outbound.duration.text = minutesToHoursMinutes(outbound.duration)
                cell.outbound.outbound.text = entities.places[outbound.originStation]?.code
                cell.outbound.inbound.text = entities.places[outbound.destinationStation]?.code
                cell.outbound.stops.text = "\(outbound.stops.count) stops"
            }
            
            if let inboundLeg = ticket.inboundLegId, let inbound = entities.legs[inboundLeg] {
                cell.inbound.departure.text = timeFormatter.string(from: inbound.departure)
                cell.inbound.arrival.text = timeFormatter.string(from: inbound.arrival)
                cell.inbound.duration.text = minutesToHoursMinutes(inbound.duration)
                cell.inbound.outbound.text = entities.places[inbound.originStation]?.code
                cell.inbound.inbound.text = entities.places[inbound.destinationStation]?.code
                cell.inbound.stops.text = "\(inbound.stops.count) stops"
            }
            
            cell.price.text = "\(Int(ticket.pricingOptions[0].price)) ₽"
        }
    }
    
    // MARK: - Private method
    
    private func minutesToHoursMinutes(_ minutes: UInt) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        var result = ""
        
        if hours > 0 {
            result += "\(hours) hours "
        }
        
        if minutes > 0 {
            result += "\(minutes) minutes "
        }
        
        result += "duration"
        return result
    }
}
