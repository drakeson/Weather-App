//
//  MainTabController.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Propeties
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    
    //MARK: - Helpers
    func configureViewControllers() {
        view.backgroundColor = .white
        let home = ViewController()
        let homeNav = tempNavigationController(image: UIImage(named: "home_unselected"), rootViewController: home)
    
        
        let search = SearchLocationViewController()
        let searchNav = tempNavigationController(image: UIImage(named: "search_unselected"), rootViewController: search)
        
        let favourites = FavouritesViewController()
        let favouritesNav = tempNavigationController(image: UIImage(named: "like_unselected"), rootViewController: favourites)
        
        let mapView = MapViewController()
        let mapViewNav = tempNavigationController(image: UIImage(named: "map"), rootViewController: mapView)
        
        viewControllers = [homeNav, searchNav, favouritesNav, mapViewNav]
        
    }
    
    func tempNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.image?.withTintColor(UIColor.white)
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
