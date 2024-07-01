//
//  RegisterView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    var coordinator: AppCoordinator?
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false

    var body: some View {
        VStack {
            header
            CustomTextFieldWrapper(text: $viewModel.email, placeholder: "Your Email", isValid: viewModel.isEmailValid)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            CustomSecureFieldWrapper(text: $viewModel.password, placeholder: "Password", isValid: viewModel.isPasswordValid)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            CustomSecureFieldWrapper(text: $viewModel.repeatPassword, placeholder: "Repeat Password", isValid: viewModel.isRepeatPasswordValid)
                .frame(height: 60)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            if let error = viewModel.registrationError {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            signInPrompt
            Spacer()
            termsAndPrivacy
            CustomButton(title: "Register", action: {
                viewModel.validateAndRegister { success in
                    if success {
                        coordinator?.showMainApp()
                    }
                }
            })
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var header: some View {
        HStack {
            Text("Registration Form")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 30)
                .padding(.leading, 20)
            Spacer()
        }
    }
    
    private var signInPrompt: some View {
        HStack {
            Text("Already have an account?")
            Button(action: {
                coordinator?.showLogin()
            }) {
                Text("Sign In")
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
    
    private var termsAndPrivacy: some View {
        HStack {
            Text("By registering, you accept")
            Button(action: {
                openURL("https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
            }) {
                Text("Terms of Use")
                    .foregroundColor(.blue)
            }
            Text("and")
            Button(action: {
                openURL("https://www.apple.com/legal/privacy/")
            }) {
                Text("Privacy Policy")
                    .foregroundColor(.blue)
            }
        }
        .font(.caption)
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    RegisterView()
}
