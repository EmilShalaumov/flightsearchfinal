//
//  SearchAirportViewController.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

protocol SearchAirportViewControllerProtocol: class {
    func reloadTableViewData()
    func removeVC()
}

class SearchAirportViewController: UIViewController {
    private let configurator: SearchAirportConfigurator
    private let interface = InterfaceFactory()
    
    /// Search airport scene presenter
    var presenter: SearchAirportPresenterProtocol?
    
    private var menuHeight: CGFloat = 0
    
    // MARK: - Interface elements
    
    private let menu: UIView = {
        let view = RoundedView(corners: [.topLeft, .topRight], radius: 5)
        view.backgroundColor = .white
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Dismiss"), for: .normal)
        return button
    }()
    
    private lazy var searchField = interface.createEditableTextFieldWithImage(img: "OutPlace", placeholder: "Start typing...")
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        return tableView
    }()
    
    // MARK: - Initializers
    
    /// Initializes SearchAirportViewController
    ///
    /// - Parameters:
    ///   - configurator: Object to configure Search Airport scene
    ///   - img: Image which is passed from location field
    init(configurator: SearchAirportConfigurator, img: String) {
        self.configurator = configurator
        
        super.init(nibName: nil, bundle: nil)

        self.configurator.configure(view: self)
        searchField.imageView.image = UIImage(named: img)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuHeight = view.frame.height - 100
        
        setupUI()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self?.menu.center.y -= (self?.menuHeight ?? 0)
            }, completion: { finished in
                self.searchField.textField.becomeFirstResponder()
        })
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        menu.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: menuHeight)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AirportCell.self, forCellReuseIdentifier: "AirportCell")
        
        menu.addSubview(dismissButton)
        menu.addSubview(searchField)
        menu.addSubview(tableView)
        
        view.addSubview(menu)
        
        dismissButton.setTopAnchor(equalTo: menu.topAnchor, constant: 8)
        dismissButton.setCenterXAnchor(equalTo: menu.centerXAnchor)
        dismissButton.setHeightAnchor(constant: 15)
        dismissButton.setWidthAnchor(constant: 36)
        
        searchField.setTopAnchor(equalTo: dismissButton.bottomAnchor, constant: 8)
        searchField.setLeftAnchor(equalTo: menu.leftAnchor)
        searchField.setRightAnchor(equalTo: menu.rightAnchor)
        
        tableView.setTopAnchor(equalTo: searchField.bottomAnchor)
        tableView.setLeftAnchor(equalTo: menu.leftAnchor)
        tableView.setRightAnchor(equalTo: menu.rightAnchor)
        tableView.setBottomAnchor(equalTo: menu.bottomAnchor, constant: -220)
    }
    
    // MARK: - Setup actions
    
    private func setupActions() {
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        searchField.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func dismissTapped() {
        presenter?.dismissTapped()
    }
    
    @objc private func textFieldChanged() {
        if let text = searchField.textField.text {
            presenter?.textFieldDidChange(text: text)
        }
    }
}

extension SearchAirportViewController: SearchAirportViewControllerProtocol {
    
    /// Calls to remove view controller from screen with animation
    func removeVC() {
        searchField.textField.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.menu.center.y += (self?.menuHeight ?? 0.0)
            self?.view.backgroundColor = UIColor(white: 0, alpha: 0)
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    /// Calls to reload airports table view data
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.separatorColor = self.interface.lineColor
            self.tableView.reloadData()
        }
    }
}

extension SearchAirportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.places.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AirportCell", for: indexPath) as? AirportCell {
            presenter?.configureCell(cell: cell, placeIndex: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.airportSelected(at: indexPath.row)
    }
}
