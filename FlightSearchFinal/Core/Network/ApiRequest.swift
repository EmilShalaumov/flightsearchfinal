//
//  ApiRequest.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

final class API {
    
    // MARK: - API connection parameters
    
    private let sourceUrl = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices"
    private let headerParams = [
        "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
        "x-rapidapi-key": "0473c91308msh4e9f4a3e9566377p171c62jsnbfb50d0badbb",
        "content-type": "application/x-www-form-urlencoded"
    ]
    
    // MARK: - Singleton
    
    private init() { }
    static var shared = API()
    
    // MARK: - Public methods
    
    /// Creates a request to get airports by search string
    ///
    /// - Parameter place: Locale parameters and search string
    /// - Returns: URL request to call from API
    func listPlacesRequest(place: PlaceListParams) -> URLRequest? {
        var urlPath = sourceUrl + "/autosuggest/v1.0"
        urlPath += "/\(place.country)/\(place.currency)/\(place.locale)/?query=\(place.queryString)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlPath
        
        guard let url = URL(string: urlPath) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headerParams
        
        return request
    }
    
    /// Creates a request to perform session for tickets search
    ///
    /// - Parameter params: Locale params, origin and destionation places, dates, passengers
    /// - Returns: URL request to call from API
    func createSessionRequest(params: CreateSessionParams) -> URLRequest? {
        let urlPath = sourceUrl + "/pricing/v1.0"
        
        guard let url = URL(string: urlPath) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.getUrlEncoded()
        request.allHTTPHeaderFields = headerParams
        
        return request
    }
    
    /// Creates a request to return found tickets by session key
    ///
    /// - Parameter key: Session key
    /// - Returns: URL request to call from API
    func pollSessionResultsRequest(key: String) -> URLRequest? {
        let urlPath = sourceUrl + "/pricing/uk2/v1.0/\(key)"
        
        guard let url = URL(string: urlPath) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headerParams
        
        return request
    }
}

extension CreateSessionParams {
    
    /// Converts object attributes to xxx-urlencoded format
    ///
    /// - Returns: Parameters in xxx-urlencoded format as Data
    func getUrlEncoded() -> Data {
        let postData = NSMutableData()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let country = "country=\(country)".data(using: String.Encoding.utf8) {
            postData.append(country)
        }
        
        if let currency = "&currency=\(currency)".data(using: String.Encoding.utf8) {
            postData.append(currency)
        }
        
        if let locale = "&locale=\(locale)".data(using: String.Encoding.utf8) {
            postData.append(locale)
        }
        
        if let origin = "&originPlace=\(originPlace?.placeId ?? "")".data(using: String.Encoding.utf8) {
            postData.append(origin)
        }
        
        if let destination = "&destinationPlace=\(destinationPlace?.placeId ?? "")".data(using: String.Encoding.utf8) {
            postData.append(destination)
        }
        
        if let date = outboundDate,
            let outDate = "&outboundDate=\(formatter.string(from: date))".data(using: String.Encoding.utf8) {
            postData.append(outDate)
        }
        
        if let date = inboundDate,
            let inDate = "&inboundDate=\(formatter.string(from: date))".data(using: String.Encoding.utf8) {
            postData.append(inDate)
        }
        
        if let adults = "&adults=\(adults)".data(using: String.Encoding.utf8) {
            postData.append(adults)
        }
        
        return postData as Data
    }
}
