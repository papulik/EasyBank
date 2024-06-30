//
//  LoginViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    @Published var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    @Published var isEmailValid: Bool = true
    @Published var isPasswordValid: Bool = true

    func validateAndLogin() {
        validateEmail()
        validatePassword()

        if isEmailValid && isPasswordValid {
            // Handle login logic here
        }
    }

    private func validateEmail() {
        isEmailValid = !email.isEmpty
    }

    private func validatePassword() {
        isPasswordValid = !password.isEmpty
    }
}
