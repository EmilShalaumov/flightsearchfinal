//
//  SearchRouter.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol SearchRouterProtocol {
    func presentSearchAirport(delegate: SearchAirportPresenterDelegate, img: String, tag: Int)
    func presentTickets(with key: String)
}

class SearchRouter: SearchRouterProtocol {
    private var view: SearchViewController
    
    /// SearchRouter initialization
    ///
    /// - Parameter view: Search view controller
    init(view: SearchViewController) {
        self.view = view
    }
    
    // MARK: - Route methods
    
    /// Presents search airport bottom menu
    ///
    /// - Parameters:
    ///   - delegate: Search presenter
    ///   - img: image to show in left of search field
    func presentSearchAirport(delegate: SearchAirportPresenterDelegate, img: String, tag: Int) {
        let searchAirportconfigurator = SearchAirportConfigurator(presenterDelegate: delegate, tag: tag)
        let searchAirportViewController = SearchAirportViewController(configurator: searchAirportconfigurator, img: img)
        view.addChildVC(viewController: searchAirportViewController)
    }
    
    /// Show tickets list scene
    ///
    /// - Parameter key: Session key
    func presentTickets(with key: String) {
        DispatchQueue.main.async {
            let service = TicketsFromAPI(key: key)
            let configurator = TicketsConfigurator(service: service)
            let ticketsViewController = TicketsViewController(configurator: configurator)
            self.view.navigationController?.pushViewController(ticketsViewController, animated: true)
        }
    }
}
