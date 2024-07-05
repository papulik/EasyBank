//
//  LoginViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation
import FirebaseAuth

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
    @Published var loginError: String?
    
    func validateAndLogin(completion: @escaping (Bool) -> Void) {
        validateEmail()
        validatePassword()
        
        if isEmailValid && isPasswordValid {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.loginError = error.localizedDescription
                    completion(false)
                } else {
                    self.loginError = nil
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }

    private func validateEmail() {
        isEmailValid = !email.isEmpty
    }

    private func validatePassword() {
        isPasswordValid = !password.isEmpty
    }
}
