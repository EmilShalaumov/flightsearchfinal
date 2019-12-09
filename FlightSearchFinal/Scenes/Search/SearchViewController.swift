//
//  SearchViewController.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

protocol SearchViewControllerProtocol: class {
    func updateFields(with params: CreateSessionParams)
    func showServerErrorAlert()
    func addChildVC(viewController: UIViewController)
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {
    private let configurator = SearchConfigurator()
    private let interface = InterfaceFactory()
    
    /// Search scene presenter
    var presenter: SearchPresenterProtocol?

    // MARK: - Interface elements
    
    private lazy var outPlace = interface.createTextFieldWithImage(img: "OutPlace", placeholder: "Choose origin place", tag: 1)
    private lazy var inPlace = interface.createTextFieldWithImage(img: "InPlace", placeholder: "Choose destination place", tag: 2)
    private lazy var outDate = interface.createEditableTextFieldWithImage(img: "OutDate", placeholder: "Add out date")
    private lazy var inDate = interface.createEditableTextFieldWithImage(img: "InDate", placeholder: "Add return date")
    private lazy var passengersField = interface.createTextFieldWithImage(img: "Passenger", placeholder: "Set passengers", tag: 3)
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = interface.cornerRadius
        button.backgroundColor = UIColor(red: 8 / 255, green: 212 / 225, blue: 125 / 225, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Search flights", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(view: self)
        
        setupUI()
        setupActions()
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        title = "Search"
        
        let components = UIView()
        view.addSubview(components)
        
        let startBgColor = UIColor(red: 6 / 255, green: 126 / 255, blue: 217 / 255, alpha: 1)
        let endBgColor = UIColor(red: 51 / 255, green: 167 / 255, blue: 255 / 255, alpha: 1)
        let bgView = GradientView()
        bgView.setColors(startColor: startBgColor, endColor: endBgColor)
        bgView.setPoints(startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        
        let paramView = UIView()
        paramView.layer.cornerRadius = interface.cornerRadius
        paramView.backgroundColor = interface.lineColor
        
        let locationView = setupLocationUI()
        let dateView = setupDateUI()
        let passView = setupPassengerUI()
        
        components.addSubview(bgView)
        components.addSubview(paramView)
        components.addSubview(searchButton)
        
        paramView.addSubview(locationView)
        paramView.addSubview(dateView)
        paramView.addSubview(passView)
        
        bgView.setTopAnchor(equalTo: view.topAnchor)
        bgView.setLeftAnchor(equalTo: view.leftAnchor)
        bgView.setRightAnchor(equalTo: view.rightAnchor)
        bgView.setBottomAnchor(equalTo: view.bottomAnchor)
        
        components.setLeftAnchor(equalTo: view.leftAnchor, constant: 16)
        components.setRightAnchor(equalTo: view.rightAnchor, constant: -16)
        components.setCenterYAnchor(equalTo: view.centerYAnchor)
        components.setCenterXAnchor(equalTo: view.centerXAnchor)
        
        paramView.setTopAnchor(equalTo: components.topAnchor)
        paramView.setLeftAnchor(equalTo: components.leftAnchor)
        paramView.setRightAnchor(equalTo: components.rightAnchor)
        
        locationView.setTopAnchor(equalTo: paramView.topAnchor)
        locationView.setLeftAnchor(equalTo: paramView.leftAnchor)
        locationView.setRightAnchor(equalTo: paramView.rightAnchor)
        
        dateView.setTopAnchor(equalTo: locationView.bottomAnchor, constant: 4)
        dateView.setLeftAnchor(equalTo: paramView.leftAnchor)
        dateView.setRightAnchor(equalTo: paramView.rightAnchor)
        
        passView.setTopAnchor(equalTo: dateView.bottomAnchor, constant: 4)
        passView.setLeftAnchor(equalTo: paramView.leftAnchor)
        passView.setRightAnchor(equalTo: paramView.rightAnchor)
        passView.setBottomAnchor(equalTo: paramView.bottomAnchor)
        
        searchButton.setHeightAnchor(constant: 60)
        searchButton.setTopAnchor(equalTo: paramView.bottomAnchor, constant: 30)
        searchButton.setLeftAnchor(equalTo: components.leftAnchor)
        searchButton.setRightAnchor(equalTo: components.rightAnchor)
        searchButton.setBottomAnchor(equalTo: components.bottomAnchor)
    }
    
    private func setupLocationUI() -> UIView {
        let locationView = RoundedView(corners: [.topLeft, .topRight], radius: interface.cornerRadius)
        locationView.backgroundColor = interface.categoryColor
        
        let line = interface.createLine()
        
        locationView.addSubview(outPlace)
        locationView.addSubview(line)
        locationView.addSubview(inPlace)
        
        outPlace.setTopAnchor(equalTo: locationView.topAnchor)
        outPlace.setLeftAnchor(equalTo: locationView.leftAnchor)
        outPlace.setRightAnchor(equalTo: locationView.rightAnchor)
        
        line.setTopAnchor(equalTo: outPlace.bottomAnchor)
        line.setLeftAnchor(equalTo: outPlace.textField.leftAnchor)
        line.setRightAnchor(equalTo: outPlace.rightAnchor)
        
        inPlace.setTopAnchor(equalTo: line.bottomAnchor)
        inPlace.setLeftAnchor(equalTo: outPlace.leftAnchor)
        inPlace.setRightAnchor(equalTo: outPlace.rightAnchor)
        inPlace.setBottomAnchor(equalTo: locationView.bottomAnchor)
        
        return locationView
    }
    
    private func setupDateUI() -> UIView {
        let dateView = UIView()
        dateView.backgroundColor = .white
        
        let line = interface.createLine()
        
        dateView.addSubview(outDate)
        dateView.addSubview(line)
        dateView.addSubview(inDate)
        
        outDate.setTopAnchor(equalTo: dateView.topAnchor)
        outDate.setLeftAnchor(equalTo: dateView.leftAnchor)
        outDate.setRightAnchor(equalTo: dateView.rightAnchor)
        
        line.setTopAnchor(equalTo: outDate.bottomAnchor)
        line.setLeftAnchor(equalTo: outDate.textField.leftAnchor)
        line.setRightAnchor(equalTo: outDate.rightAnchor)
        
        inDate.setTopAnchor(equalTo: line.bottomAnchor)
        inDate.setLeftAnchor(equalTo: outDate.leftAnchor)
        inDate.setRightAnchor(equalTo: outDate.rightAnchor)
        inDate.setBottomAnchor(equalTo: dateView.bottomAnchor)
        
        return dateView
    }
    
    private func setupPassengerUI() -> UIView {
        let passView = RoundedView(corners: [.bottomLeft, .bottomRight], radius: interface.cornerRadius)
        passView.backgroundColor = .white
        passengersField.textField.text = "1 passenger"
        
        passView.addSubview(passengersField)
        
        passengersField.setTopAnchor(equalTo: passView.topAnchor)
        passengersField.setLeftAnchor(equalTo: passView.leftAnchor)
        passengersField.setRightAnchor(equalTo: passView.rightAnchor)
        passengersField.setBottomAnchor(equalTo: passView.bottomAnchor)
        
        return passView
    }
    
    private func setupDatePicker() {
        outDate.textField.inputView = datePicker
        let outToolbar = UIToolbar()
        outToolbar.sizeToFit()
        let outDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(outDateSelected))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        outToolbar.setItems([flexSpace, outDoneButton], animated: true)
        outDate.textField.inputAccessoryView = outToolbar
        
        inDate.textField.inputView = datePicker
        let inToolBar = UIToolbar()
        inToolBar.sizeToFit()
        let inDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(inDateSelected))
        inToolBar.setItems([flexSpace, inDoneButton], animated: true)
        inDate.textField.inputAccessoryView = inToolBar
    }
    
    // MARK: - Setup actions
    
    private func setupActions() {
        outPlace.textField.addTarget(self, action: #selector(placeItemTapped(sender:)), for: .touchCancel)
        inPlace.textField.addTarget(self, action: #selector(placeItemTapped(sender:)), for: .touchCancel)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func placeItemTapped(sender: UITextField) {
        presenter?.placeItemTapped(tag: sender.tag)
    }
    
    @objc private func outDateSelected() {
        presenter?.outDateItemTapped(date: datePicker.date)
        view.endEditing(true)
    }
    
    @objc private func inDateSelected() {
        presenter?.inDateItemTapped(date: datePicker.date)
        view.endEditing(true)
    }
    
    @objc private func searchButtonTapped() {
        presenter?.searchButtonTapped()
    }
    
    // MARK: - Presenter interaction
    
    /// Update search parameter fields
    ///
    /// - Parameter params: Search tickets parameters
    func updateFields(with params: CreateSessionParams) {
        outPlace.textField.text = params.originPlace?.placeName
        inPlace.textField.text = params.destinationPlace?.placeName
        
        if let date = params.outboundDate {
            outDate.textField.text = interface.dateFormatter.string(from: date)
        }
        
        if let date = params.inboundDate {
            inDate.textField.text = interface.dateFormatter.string(from: date)
        }
    }
    
    /// Show UIAlertController when server error is occured
    func showServerErrorAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Server error", message: "Server error occured. Please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Add airport search bottom menu to view
    ///
    /// - Parameter viewController: Airport search view controller
    func addChildVC(viewController: UIViewController) {
        viewController.view.frame = view.frame
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
