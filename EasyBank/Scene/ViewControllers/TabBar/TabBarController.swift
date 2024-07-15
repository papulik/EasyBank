//
//  TabBarController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class TabBarController: UITabBarController {
    var onboardingCoordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.onboardingCoordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setupTabBarAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = .white
            itemAppearance.selected.iconColor = .white
            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
        }
    }
}
