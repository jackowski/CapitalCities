//
//  SceneDelegate.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 23/01/2021.
//

import UIKit
import CitiesRepository
import FavouritesRepository

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let citiesListViewController = CitiesListViewController()
            citiesListViewController.viewModel = CitiesListViewModel(
                citiesRepository: CitiesRepository(),
                favouritesRepository: FavouritesRepository())
            let rootViewController = UINavigationController(rootViewController: citiesListViewController)
            window.rootViewController = rootViewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

