//
//  TicketCell.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

class TicketCell: UITableViewCell {
    /// Price field
    let price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 13 / 255, green: 133 / 255, blue: 223 / 255, alpha: 1)
        return label
    }()
    
    /// Outbound leg view
    let outbound = LegView()
    /// Inbound leg view
    let inbound = LegView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let baseView = UIView()
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 5
        
        baseView.addSubview(outbound)
        baseView.addSubview(inbound)
        baseView.addSubview(price)
        
        addSubview(baseView)
        
        baseView.setTopAnchor(equalTo: topAnchor, constant: 6)
        baseView.setLeftAnchor(equalTo: leftAnchor, constant: 16)
        baseView.setRightAnchor(equalTo: rightAnchor, constant: -16)
        baseView.setBottomAnchor(equalTo: bottomAnchor, constant: -6)
        
        outbound.setTopAnchor(equalTo: baseView.topAnchor, constant: 11)
        outbound.setLeftAnchor(equalTo: baseView.leftAnchor, constant: 20)
        outbound.setRightAnchor(equalTo: baseView.rightAnchor, constant: -20)
        
        inbound.setTopAnchor(equalTo: outbound.bottomAnchor)
        inbound.setLeftAnchor(equalTo: outbound.leftAnchor)
        inbound.setRightAnchor(equalTo: outbound.rightAnchor)
        
        price.setTopAnchor(equalTo: inbound.bottomAnchor, constant: 11)
        price.setLeftAnchor(equalTo: outbound.leftAnchor)
        price.setBottomAnchor(equalTo: baseView.bottomAnchor, constant: -11)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LegView: UIView {
    /// Time of departure
    lazy var departure = createBlackLbl()
    /// Time of arrival
    lazy var arrival = createBlackLbl()
    /// Flight duration
    lazy var duration = createBlackLbl()
    /// Origin airport
    lazy var outbound = createGrayLbl()
    /// Destination airport
    lazy var inbound = createGrayLbl()
    /// Number of stops
    lazy var stops = createGrayLbl()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        addSubview(departure)
        addSubview(arrival)
        addSubview(duration)
        addSubview(outbound)
        addSubview(inbound)
        addSubview(stops)
        
        departure.setTopAnchor(equalTo: topAnchor, constant: 4)
        departure.setLeftAnchor(equalTo: leftAnchor)
        
        arrival.setLeftAnchor(equalTo: leftAnchor, constant: 69)
        arrival.setCenterYAnchor(equalTo: departure.centerYAnchor)
        
        outbound.setTopAnchor(equalTo: departure.bottomAnchor)
        outbound.setLeftAnchor(equalTo: departure.leftAnchor)
        outbound.setBottomAnchor(equalTo: bottomAnchor, constant: -4)
        
        inbound.setLeftAnchor(equalTo: arrival.leftAnchor)
        inbound.setCenterYAnchor(equalTo: outbound.centerYAnchor)
        
        duration.setLeftAnchor(equalTo: rightAnchor, constant: -170)
        duration.setCenterYAnchor(equalTo: departure.centerYAnchor)
        
        stops.setLeftAnchor(equalTo: duration.leftAnchor)
        stops.setCenterYAnchor(equalTo: outbound.centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface element creation factory methods
    
    private func createBlackLbl() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }
    
    private func createGrayLbl() -> UILabel {
        let label = createBlackLbl()
        label.textColor = .lightGray
        return label
    }
}
