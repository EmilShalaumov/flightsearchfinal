//
//  SearchViewControllerMock.swift
//  FlightSearchFinalTests
//
//  Created by Эмиль Шалаумов on 11.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation
import UIKit
@testable import FlightSearchFinal

class SearchViewControllerMock: SearchViewControllerProtocol {
    var serverErrorAlertCallsCount = 0
    
    func updateFields(with params: CreateSessionParams) {
        return
    }
    
    func showServerErrorAlert() {
        serverErrorAlertCallsCount += 1
    }
    
    func addChildVC(viewController: UIViewController) {
        return
    }
    
    
}
