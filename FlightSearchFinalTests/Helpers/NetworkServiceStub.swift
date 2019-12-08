//
//  NetworkServiceStub.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
@testable import FlightSearchFinal

class NetworkServiceStub: NetworkServiceProtocol {
    private var sourceFile: Data?
    private var responseLink: String?
    
    func setSourceFile(name: String) {
        sourceFile = Bundle(for: type(of: self)).decode(name)
    }
    
    func setResponseLink(_ link: String) {
        responseLink = link
    }
    
    func performTaskReturningBody(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        completion(.success(self.sourceFile))
    }
    
    func performTaskReturningHeader(_ request: URLRequest, completion: @escaping (Result<HTTPURLResponse?, Error>) -> Void) {
        completion(
            .success(HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                     statusCode: 201,
                                     httpVersion: "1.8",
                                     headerFields: ["Location": responseLink ?? ""])))
    }
    
//    func performTaskReturningHeader(_ request: URLRequest, completion: @escaping (Result<HTTPURLResponse?, Error>) -> Void) {
//
//    }
//
//    func performTaskReturningBody(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
//    {
//        completion(.success(self.sourceFile))
//    }
}
