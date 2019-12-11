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
    func ticketCellDropped(with index: Int)
}

class TicketsPresenter: TicketsPresenterProtocol {
    private weak var view: TicketsViewControllerProtocol?
    private let service: TicketsServiceProtocol
    private let persistence: TicketPersistenceProtocol?
    
    private var entities = AllEntities()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    /// Return count of tickets currently received from api / storage
    var ticketsCount: Int {
        return entities.itineraries.count
    }
    
    /// Initializes presenter for Tickets scene
    ///
    /// - Parameters:
    ///   - view: Tickets view controller
    ///   - service: API / Storage to get tickets data
    init(view: TicketsViewControllerProtocol, service: TicketsServiceProtocol, persistence: TicketPersistenceProtocol? = nil) {
        self.view = view
        self.service = service
        self.persistence = persistence
    }
    
    // MARK: - Protocol methods
    
    /// Load tickets from storage / API
    func loadTickets() {
        service.getTickets { entities in
            self.entities = entities ?? AllEntities()
            self.view?.reloadTableViewData()
        }
    }
    
    /// Configure Ticket table view cell
    ///
    /// - Parameters:
    ///   - cell: Ticket representation table view cell
    ///   - index: number of ticket / cell number
    func configureCell(_ cell: TicketCell, index: Int) {
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
    
    /// Calls when ticket drag-n-dropped to "star" item
    ///
    /// - Parameter index: Index of ticket cell
    func ticketCellDropped(with index: Int) {
        persistence?.saveTicket(entities: entities, index: index) { result in
            if result {
                print("Success")
                let path = FileManager
                    .default
                    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                    .last?
                    .absoluteString
                    .replacingOccurrences(of: "file://", with: "")
                    .removingPercentEncoding
                
                print("DB path: \(path ?? "Not found")")
            } else {
                print("Failure")
            }
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
