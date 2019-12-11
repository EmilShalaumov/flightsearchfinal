//
//  AppDelegate.swift
//  FlightSearchFinal
//
//  Created by Эмиль Шалаумов on 08.12.2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let searchViewController = SearchViewController()
        let searchNavViewController = CustomNavViewController(rootViewController: searchViewController)
        searchViewController.tabBarItem.image = UIImage(named: "FlightsItem")
        
        let savedService = TicketPersistence()
        let savedConfigurator = TicketsConfigurator(service: savedService)
        let savedViewController = TicketsViewController(configurator: savedConfigurator, title: "Favorites")
        let savedNavViewController = CustomNavViewController(rootViewController: savedViewController)
        savedNavViewController.tabBarItem.image = UIImage(named: "FavoritesItem")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNavViewController, savedNavViewController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()       
        
        return true
    }
}

