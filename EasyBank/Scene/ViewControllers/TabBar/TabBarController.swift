//
//  TabBarController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        viewControllers = [homeVC]
    }
}
