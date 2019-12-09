//
//  TicketsViewController.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 09.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol TicketsViewControllerProtocol: class {
    func reloadTableViewData()
}

class TicketsViewController: UITableViewController, TicketsViewControllerProtocol {
    private let interface = InterfaceFactory()
    private let configurator: TicketsConfigurator
    
    /// Tickets presenter reference
    var presenter: TicketsPresenterProtocol?
    
    // MARK: - Initializers
    
    /// Initializes tickets scene with predefined get data service in configurator
    ///
    /// - Parameter configurator: Tickets scene configurator
    init(configurator: TicketsConfigurator) {
        self.configurator = configurator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(view: self)

        view.backgroundColor = interface.lineColor
        
        setupTableView()
        presenter?.loadTickets()
    }
    
    // MARK: - Setup Table View
    
    private func setupTableView() {
        tableView.separatorColor = .clear
        tableView.register(TicketCell.self, forCellReuseIdentifier: "TicketCell")
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
    }

    // MARK: - Protocol method
    
    /// Call from presenter to reload table view data
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.ticketsCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell {
            presenter?.configureCell(cell, index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

extension TicketsViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard let stringData = "Dragging item".data(using: .utf8) else {
            return []
        }
        
        let itemProvider = NSItemProvider(item: stringData as NSData, typeIdentifier: kUTTypePlainText as String)
        session.localContext = UInt(indexPath.row)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        setupAddToFavoritesBarButtonItem()
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Setup Bar Button item
    
    private func setupAddToFavoritesBarButtonItem() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "FavoritesButton"), for: .normal)
        button.addInteraction(UIDropInteraction(delegate: self))
        let addToFavoritesBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = addToFavoritesBarButtonItem
    }
}

extension TicketsViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            session.loadObjects(ofClass: NSString.self) { (items) in
                guard let _ = items.first as? String else {
                    return
                }
                
                if let index = session.localDragSession?.localContext as? UInt {
                    print("Cell \(index) performed to drop")
                }
            }
        }
    }
}
