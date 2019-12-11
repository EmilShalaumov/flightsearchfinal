//
//  FlightSearchAPIStub.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
@testable import FlightSearchFinal

class FlightSearchAPIStub: FlightSearchAPIProtocol {
    var createSessionKey: String?
    
    func listPlaces(by queryString: String, completion: @escaping ([Airport]) -> Void) {
        completion([])
    }
    
    func createSession(params: CreateSessionParams, completion: @escaping (String?) -> Void) {
        completion(createSessionKey)
    }
    
    func pollSessionResults(with key: String, completion: @escaping (AllEntities?) -> Void) {
        completion(nil)
    }
    
    
}
