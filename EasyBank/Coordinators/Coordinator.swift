//
//  Coordinator.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
