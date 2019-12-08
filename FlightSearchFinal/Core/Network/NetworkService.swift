//
//  NetworkService.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func performTaskReturningBody(_ request: URLRequest, completion: @escaping(Result<Data?, Error>) -> Void)
    func performTaskReturningHeader(_ request: URLRequest, completion: @escaping(Result<HTTPURLResponse?, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let session = URLSession.shared
    
    /// Performs a network request and returns response body
    /// Waits for 200 - OK response code as API returns it when contains response data in body
    ///
    /// - Parameters:
    ///   - request: HTTP / HTTPS request contained of predefined parameters
    ///   - completion: returns response body of Data type in case of successful execution, otherwise returns error with description
    func performTaskReturningBody(_ request: URLRequest, completion: @escaping(Result<Data?, Error>) -> Void) {
        performDataTask(request, expectedCode: 200) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Performs a network request and returns response header
    /// Waits for 201 - Created response code as API returns it when contains session key in header
    ///
    /// - Parameters:
    ///   - request: HTTP / HTTPS request contained of predefined parameters
    ///   - completion: returns response header of HTTPURLResponse type in case of successful execution, otherwise returns error with description
    func performTaskReturningHeader(_ request: URLRequest, completion: @escaping(Result<HTTPURLResponse?, Error>) -> Void) {
        performDataTask(request, expectedCode: 201) { result in
            switch result {
            case .success(let response):
                completion(.success(response.header))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    private func performDataTask(_ request: URLRequest,
                                 expectedCode: Int,
                                 completion: @escaping(Result<(header: HTTPURLResponse, data: Data?), Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode == expectedCode {
                    completion(.success((response, data)))
                } else {
                    let customError = NSError(domain: "Invalid response code", code: response.statusCode, userInfo: nil)
                    completion(.failure(customError))
                }
            }
        }.resume()
    }
}
