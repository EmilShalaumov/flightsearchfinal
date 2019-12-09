//
//  GradientView.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { return layer as? CAGradientLayer ?? CAGradientLayer() }
    
    /// Set colors of gradient view
    ///
    /// - Parameters:
    ///   - startColor: Start point color
    ///   - endColor: End point color
    func setColors(startColor: UIColor, endColor: UIColor) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    /// Set points of gradient view
    ///
    /// - Parameters:
    ///   - startPoint: Point of gradient start
    ///   - endPoint: Point of gradient end
    func setPoints(startPoint: CGPoint, endPoint: CGPoint) {
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
