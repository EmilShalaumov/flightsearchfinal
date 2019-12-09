//
//  SearchAirportPresenter.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol SearchAirportPresenterProtocol: class {
    var places: [Airport] { get }
    func textFieldDidChange(text: String)
    func configureCell(cell: AirportCell, placeIndex: Int)
    func dismissTapped()
    func airportSelected(at index: Int)
}

protocol SearchAirportPresenterDelegate: class {
    func placeItemSelected(with tag: Int, place: Airport)
}

class SearchAirportPresenter: SearchAirportPresenterProtocol {
    private weak var view: SearchAirportViewControllerProtocol?
    private let api: FlightSearchAPIProtocol
    
    /// Search airport presenter returns chosen airport by delegate
    weak var delegate: SearchAirportPresenterDelegate?
    
    private let tag: Int
    
    /// List of airports received from API
    var places: [Airport] = []
    
    private let searchDelayQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    // MARK: - Initializers
    
    /// Initializes Search airport scene presenter
    ///
    /// - Parameters:
    ///   - view: Search Airport View Controller
    ///   - api: Flight search API service
    ///   - tag: Tag of field to which airport will be returned
    init(view: SearchAirportViewControllerProtocol, api: FlightSearchAPIProtocol, tag: Int) {
        self.view = view
        self.api = api
        self.tag = tag
    }
    
    // MARK: - SearchAirportPresenterProtocol methods
    
    /// Method is called to get list of places from API when text in search text field is changed by user
    ///
    /// - Parameter text: Search string
    func textFieldDidChange(text: String) {
        searchDelayQueue.isSuspended = true
        searchDelayQueue.cancelAllOperations()
        
        searchDelayQueue.addOperation {
            self.api.listPlaces(by: text) { airports in
                self.places = airports
                self.view?.reloadTableViewData()
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.searchDelayQueue.isSuspended = false
        }
    }
    
    /// Configure Airport cell
    ///
    /// - Parameters:
    ///   - cell: Airport cell
    ///   - placeIndex: index of table view cell
    func configureCell(cell: AirportCell, placeIndex: Int) {
        if placeIndex < places.count {
            let place = places[placeIndex]
            cell.configure(airport: place.placeName, country: place.countryName, code: String(place.placeId.dropLast(4)))
        }
    }
    
    /// Close the scene (when dismiss button is tapped)
    func dismissTapped() {
        view?.removeVC()
    }
    
    /// Calls when airport was selected by user / pass airport object to delegate
    ///
    /// - Parameter index: Index of table view cell
    func airportSelected(at index: Int) {
        view?.removeVC()
        delegate?.placeItemSelected(with: tag, place: places[index])
    }
}
