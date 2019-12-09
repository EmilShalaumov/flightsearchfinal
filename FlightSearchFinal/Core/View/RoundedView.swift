//
//  RoundedView.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

import UIKit

class RoundedView: UIView {
    private let corners: UIRectCorner
    private let radius: CGFloat
    
    /// Initializes view with predefined rounded corners
    ///
    /// - Parameters:
    ///   - corners: Array of corners needs to be rounded
    ///   - radius: Corner radius
    init(corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
