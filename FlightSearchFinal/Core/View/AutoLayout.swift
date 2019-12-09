//
//  AutoLayout.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Set top anchor of view
    ///
    /// - Parameters:
    ///   - equalTo: Anchor of element to be linked to object's top anchor
    ///   - constant: Float value
    func setTopAnchor(equalTo: NSLayoutYAxisAnchor, constant: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let constant = constant {
            topAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
            return
        }
        topAnchor.constraint(equalTo: equalTo).isActive = true
    }
    
    /// Set left anchor of view
    ///
    /// - Parameters:
    ///   - equalTo: Anchor of element to be linked to object's left anchor
    ///   - constant: Float value
    func setLeftAnchor(equalTo: NSLayoutXAxisAnchor, constant: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let constant = constant {
            leftAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
            return
        }
        leftAnchor.constraint(equalTo: equalTo).isActive = true
    }
    
    /// Set top bottom of view
    ///
    /// - Parameters:
    ///   - equalTo: Anchor of element to be linked to object's bottom anchor
    ///   - constant: Float value
    func setBottomAnchor(equalTo: NSLayoutYAxisAnchor, constant: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let constant = constant {
            bottomAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
            return
        }
        bottomAnchor.constraint(equalTo: equalTo).isActive = true
    }
    
    /// Set right anchor of view
    ///
    /// - Parameters:
    ///   - equalTo: Anchor of element to be linked to object's right anchor
    ///   - constant: Float value
    func setRightAnchor(equalTo: NSLayoutXAxisAnchor, constant: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let constant = constant {
            rightAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
            return
        }
        rightAnchor.constraint(equalTo: equalTo).isActive = true
    }
    
    /// Set width anchor of view
    ///
    /// - Parameters:
    ///   - constant: Float value
    func setWidthAnchor(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    /// Set height anchor of view
    ///
    /// - Parameters:
    ///   - constant: Float value
    func setHeightAnchor(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    /// Set center Y anchor of view
    ///
    /// - Parameter equalTo: Anchor of element to be linked to object's center Y anchor
    func setCenterYAnchor(equalTo: NSLayoutYAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: equalTo).isActive = true
    }
    
    /// Set center X anchor of view
    ///
    /// - Parameter equalTo: Anchor of element to be linked to object's center X anchor
    func setCenterXAnchor(equalTo: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: equalTo).isActive = true
    }
}
