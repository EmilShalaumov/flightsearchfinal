//
//  SearchConfigurator.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class SearchConfigurator {
    
    /// Configure architecture entities for Search scene
    ///
    /// - Parameter view: Search view controller
    func configure(view: SearchViewController) {
        let network = NetworkService()
        let api = FlightSearchAPI(with: network)
        let router = SearchRouter(view: view)
        let presenter = SearchPresenter(view: view, router: router, api: api)
        
        view.presenter = presenter
    }
}
