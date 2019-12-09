//
//  FlightSearchAPI.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol FlightSearchAPIProtocol {
    func listPlaces(by queryString: String, completion: @escaping([Airport]) -> Void)
    func createSession(params: CreateSessionParams, completion: @escaping(String?) -> Void)
    func pollSessionResults(with key: String, completion: @escaping(AllEntities?) -> Void)
}

final class FlightSearchAPI: FlightSearchAPIProtocol {
    private let service: NetworkServiceProtocol
    private let apiRequest = API.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }()
    
    typealias json = JSONSerialization
    
    // MARK: - Initializer
    
    init(with service: NetworkServiceProtocol) {
        self.service = service
    }
    
    // MARK: - API methods
    
    /// Calls network service request to get list of airports
    ///
    /// - Parameters:
    ///   - queryString: Key to find an airport
    ///   - completion: Returns list of Airport type objects
    func listPlaces(by queryString: String, completion: @escaping([Airport]) -> Void) {
        let params = PlaceListParams(query: queryString)
        let urlRequest = apiRequest.listPlacesRequest(place: params)
        
        guard let request = urlRequest else {
            completion([])
            return
        }
        
        service.performTaskReturningBody(request) { [weak self] result in
            var places: [Airport] = []
            
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                
                guard let jsonDict = try? json.jsonObject(with: data, options: .init()) as? Dictionary<String, Any> else {
                    return
                }
                
                if let dictionary = jsonDict["Places"], let placeList = try? self?.decoder.decode([Airport].self, from: json.data(withJSONObject: dictionary)) {
                    places.append(contentsOf: placeList)
                }
            case .failure(let error):
                print("List places error: \(error.localizedDescription)")
            }
            
            completion(places)
        }
    }
    
    /// Calls to perform tickets search session with returning session key
    ///
    /// - Parameters:
    ///   - params: List of parameters to create session
    ///   - completion: Block return session key as String value
    func createSession(params: CreateSessionParams, completion: @escaping(String?) -> Void) {
        let urlRequest = apiRequest.createSessionRequest(params: params)
        
        guard let request = urlRequest else {
            completion(nil)
            return
        }
        
        service.performTaskReturningHeader(request) { result in
            switch result {
            case .success(let header):
                guard let header = header else {
                    break
                }
                
                guard let contentType = header.allHeaderFields["Location"] as? String, let range = contentType.lastIndex(of: "/") else {
                    print("Error: Response doesn't contain Location field")
                    break
                }
                
                let sessionKey = contentType[contentType.index(after:range)...]
                completion(String(sessionKey))
                return
            case .failure(let error):
                print("Create session error: \(error.localizedDescription)")
            }
            completion(nil)
        }
    }
    
    /// Calls to populate tickets table view
    ///
    /// - Parameters:
    ///   - key: Session key as String
    ///   - completion: Returns AllEntities object which contains places, carriers, legs and itineraries
    func pollSessionResults(with key: String, completion: @escaping(AllEntities?) -> Void) {
        let urlRequest = apiRequest.pollSessionResultsRequest(key: key)
        
        guard let request = urlRequest else {
            completion(nil)
            return
        }
        
        service.performTaskReturningBody(request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    break
                }
                
                guard let jsonDict = try? json.jsonObject(with: data, options: .init()) as? Dictionary<String, Any> else {
                    break
                }
                
                var entities = AllEntities()
                
                entities.places = self.getEntityWithIntKey(from: jsonDict["Places"])
                entities.carriers = self.getEntityWithIntKey(from: jsonDict["Carriers"])
                entities.legs = self.getLegs(from: jsonDict["Legs"])
                entities.itineraries = self.getItineraries(from: jsonDict["Itineraries"])
                completion(entities)
                return
            case .failure(let error):
                print("Poll session result error: \(error)")
            }
            completion(nil)
        }
    }
    
    // MARK: - Parser methods
    
    private func getEntityWithIntKey<T: ObjectWithId>(from source: Any?) -> [UInt: T] {
        var objects: [UInt: T] = [:]
        
        guard let source = source as? [Any] else {
            return objects
        }
        
        for i in stride(from: source.count - 1, through: 0, by: -1) {
            guard let jsonSource = try? JSONSerialization.data(withJSONObject: source[i]) else {
                continue
            }
            
            if let object = try? decoder.decode(T.self, from: jsonSource) {
                objects[object.id] = object
            }
        }
        
        return objects
    }
    
    private func getLegs(from source: Any?) -> [String: Leg] {
        var legs: [String: Leg] = [:]
        
        guard let source = source as? [Any] else {
            return legs
        }
        
        for i in stride(from: source.count - 1, through: 0, by: -1) {
            let jsonSource = try? JSONSerialization.data(withJSONObject: source[i])
            
            if let data = jsonSource, let leg = try? decoder.decode(Leg.self, from: data) {
                legs[leg.id] = leg
            }
        }
        
        return legs
    }
    
    private func getItineraries(from source: Any?) -> [Itinerary] {
        var itineraries: [Itinerary] = []
        
        guard let source = source, let jsonSource = try? JSONSerialization.data(withJSONObject: source) else {
            return itineraries
        }
        
        if let array = try? decoder.decode([Itinerary].self, from: jsonSource) {
            itineraries = array
        }
        
        return itineraries
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
