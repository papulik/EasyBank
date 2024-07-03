//
//  RegisterViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import FirebaseAuth
import FirebaseFirestore

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
    @Published var registrationError: String?

    func validateAndRegister(completion: @escaping (Bool) -> Void) {
        validateEmail()
        validatePassword()
        validateRepeatPassword()

        if isEmailValid && isPasswordValid && isRepeatPasswordValid {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.registrationError = error.localizedDescription
                    completion(false)
                } else {
                    self.registrationError = nil
                    self.createUserDocument(authResult: authResult) { success in
                        completion(success)
                    }
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

    private func validateRepeatPassword() {
        isRepeatPasswordValid = password == repeatPassword
    }
    
    private func createUserDocument(authResult: AuthDataResult?, completion: @escaping (Bool) -> Void) {
        guard let uid = authResult?.user.uid else { return }
        let emailParts = email.split(separator: "@")
        let userName = String(emailParts.first ?? "")
        let user = User(id: uid, email: email, balance: 2493.50, name: userName)
        FirestoreService.shared.createUser(uid: uid, user: user) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                self.registrationError = error.localizedDescription
                completion(false)
            }
        }
    }
}
