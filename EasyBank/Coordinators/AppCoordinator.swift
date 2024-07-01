//
//  OnboardingCoordinator.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import UIKit
import SwiftUI

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onboardingViewController = OnBoardingVC()
        onboardingViewController.coordinator = self
        navigationController.pushViewController(onboardingViewController, animated: false)
    }

    func showRegister() {
        var registerView = RegisterView()
        registerView.coordinator = self
        let hostingController = UIHostingController(rootView: registerView)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func showLogin() {
        var loginView = LoginView()
        loginView.coordinator = self
        let hostingController = UIHostingController(rootView: loginView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func showMainApp() {
        let tabBarController = TabBarController(coordinator: self)
        setupTabBarController(tabBarController)
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func setupTabBarController(_ tabBarController: TabBarController) {
        let homeViewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.coordinator = self
        
        let homeNavigationController = UINavigationController(rootViewController: homeVC)

        tabBarController.viewControllers = [homeNavigationController]
    }
}
