//
//  TabBarViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 12/08/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: DashboardViewController(), title: NSLocalizedString("Dashboard", comment: ""), image: UIImage(systemName: "house") ?? UIImage()),
            createNavController(for: ProductViewController(), title: NSLocalizedString("Product", comment: ""), image: UIImage(systemName: "person") ?? UIImage()),
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
