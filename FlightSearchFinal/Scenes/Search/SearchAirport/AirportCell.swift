//
//  AirportCell.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

class AirportCell: UITableViewCell {
    private let airport: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let country: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    private let code: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let plane: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Plane")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(airport)
        addSubview(country)
        addSubview(plane)
        addSubview(code)
        
        code.setCenterYAnchor(equalTo: centerYAnchor)
        code.setRightAnchor(equalTo: rightAnchor)
        code.setWidthAnchor(constant: 50)
        
        plane.setCenterYAnchor(equalTo: centerYAnchor)
        plane.setRightAnchor(equalTo: code.leftAnchor)
        plane.setHeightAnchor(constant: 20)
        plane.setWidthAnchor(constant: 20)
        
        airport.setTopAnchor(equalTo: topAnchor, constant: 8)
        airport.setLeftAnchor(equalTo: leftAnchor, constant: 18)
        airport.setRightAnchor(equalTo: plane.leftAnchor)
        airport.setHeightAnchor(constant: 25)
        
        country.setTopAnchor(equalTo: airport.bottomAnchor)
        country.setLeftAnchor(equalTo: airport.leftAnchor)
        country.setRightAnchor(equalTo: airport.rightAnchor)
        country.setBottomAnchor(equalTo: bottomAnchor, constant: -8)
        country.setHeightAnchor(constant: 25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure table view cell fields
    ///
    /// - Parameters:
    ///   - airport: Airport name
    ///   - country: Country name
    ///   - code: Airport code
    func configure(airport: String, country: String, code: String) {
        self.airport.text = airport
        self.country.text = country
        self.code.text = code
    }
}
