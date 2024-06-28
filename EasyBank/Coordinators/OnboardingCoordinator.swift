//
//  OnboardingCoordinator.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import UIKit
import SwiftUI

class OnboardingCoordinator: Coordinator {
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
        let registerView = RegisterView()
        let hostingController = UIHostingController(rootView: registerView)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func showLogin() {
        let loginView = LoginView()
        let hostingController = UIHostingController(rootView: loginView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
