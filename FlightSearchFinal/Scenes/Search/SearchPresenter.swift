//
//  SearchPresenter.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol SearchPresenterProtocol: class {
    func placeItemTapped(tag: Int)
    func outDateItemTapped(date: Date)
    func inDateItemTapped(date: Date)
    func searchButtonTapped()
}

class SearchPresenter: SearchPresenterProtocol, SearchAirportPresenterDelegate {
    private weak var view: SearchViewControllerProtocol?
    private let router: SearchRouterProtocol
    private let api: FlightSearchAPIProtocol
    private var createSessionParams = CreateSessionParams()
    
    // MARK: - Initializer
    
    /// Search presenter initialization
    ///
    /// - Parameters:
    ///   - view: Search view controller
    ///   - router: Search router
    ///   - api: Flight search API service
    init(view: SearchViewControllerProtocol, router: SearchRouterProtocol, api: FlightSearchAPIProtocol) {
        self.view = view
        self.router = router
        self.api = api
    }
    
    // MARK: - SearchPresenterProtocol methods
    
    /// Calls when it's necessary to choose origin or destination location
    ///
    /// - Parameter tag: Place field tag (1 - Origin, 2 - Destination)
    func placeItemTapped(tag: Int) {
        let imgName = tag == 1 ? "OutPlace" : "InPlace"
        router.presentSearchAirport(delegate: self, img: imgName, tag: tag)
    }
    
    /// Calls when outbound date is selected
    ///
    /// - Parameter date: Outbound date
    func outDateItemTapped(date: Date) {
        createSessionParams.outboundDate = date
        view?.updateFields(with: createSessionParams)
    }
    
    /// Calls when inbound date is selected
    ///
    /// - Parameter date: Inbound date
    func inDateItemTapped(date: Date) {
        createSessionParams.inboundDate = date
        view?.updateFields(with: createSessionParams)
    }
    
    /// Calls when all predefined parameters are set and tickets screen needs to be show
    func searchButtonTapped() {
        api.createSession(params: createSessionParams) { [weak self] key in
            if let key = key {
                let title = self?.setTitleForTicketsScene() ?? ""
                self?.router.presentTickets(with: key, title: title)
            } else {
                self?.view?.showServerErrorAlert()
            }
        }
    }
    
    // MARK: - SearchAirportPresenterDelegate methods
    
    /// Method returns airport that was selected in Search airport scene
    ///
    /// - Parameters:
    ///   - tag: field tag (1 - origin, 2 - destination)
    ///   - place: Airport object
    func placeItemSelected(with tag: Int, place: Airport) {
        if tag == 1 {
            createSessionParams.originPlace = place
        } else {
            createSessionParams.destinationPlace = place
        }
        view?.updateFields(with: createSessionParams)
    }
    
    private func setTitleForTicketsScene() -> String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter
        }()
        
        let originCode = String((createSessionParams.originPlace?.placeId ?? "").dropLast(4))
        let destCode = String((createSessionParams.destinationPlace?.placeId ?? "").dropLast(4))
        let depDate = dateFormatter.string(from: createSessionParams.outboundDate ?? Date())
        
        var title = "\(originCode)-\(destCode), \(depDate)"
        
        if let inboundDate = createSessionParams.inboundDate {
            let arrDate = dateFormatter.string(from: inboundDate)
            title += "-\(arrDate)"
        }
        
        return title
    }
}
