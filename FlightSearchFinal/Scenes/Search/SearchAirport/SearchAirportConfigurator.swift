//
//  SearchAirportConfigurator.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class SearchAirportConfigurator {
    private let searchAirportPresenterDelegate: SearchAirportPresenterDelegate
    private let tag: Int
    
    /// Initializes Search airport scene configurator
    ///
    /// - Parameters:
    ///   - presenterDelegate: Search scene presenter to receive airport object
    ///   - tag: Tag of location field
    init(presenterDelegate: SearchAirportPresenterDelegate, tag: Int) {
        self.searchAirportPresenterDelegate = presenterDelegate
        self.tag = tag
    }
    
    /// Configures search airport scene
    ///
    /// - Parameter view: Search airport scene view controller
    func configure(view: SearchAirportViewController) {
        let network = NetworkService()
        let api = FlightSearchAPI(with: network)
        let presenter = SearchAirportPresenter(view: view, api: api, tag: tag)
        presenter.delegate = searchAirportPresenterDelegate
        
        view.presenter = presenter
    }
}
