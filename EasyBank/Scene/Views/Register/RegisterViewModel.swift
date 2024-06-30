//
//  RegisterViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation

class RegisterViewModel: ObservableObject {
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
    @Published var repeatPassword: String = "" {
        didSet {
            validateRepeatPassword()
        }
    }
    @Published var isEmailValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isRepeatPasswordValid: Bool = true

    func validateAndRegister() {
        validateEmail()
        validatePassword()
        validateRepeatPassword()

        if isEmailValid && isPasswordValid && isRepeatPasswordValid {
            // Handle registration logic here
        }
    }

    private func validateEmail() {
        isEmailValid = !email.isEmpty
    }

    private func validatePassword() {
        isPasswordValid = !password.isEmpty
    }

    private func validateRepeatPassword() {
        isRepeatPasswordValid = password == repeatPassword
    }
}
