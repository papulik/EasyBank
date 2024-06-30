//
//  LoginView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    weak var coordinator: OnboardingCoordinator?

    var body: some View {
        ScrollView {
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
                if let error = viewModel.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                CustomButton(title: "Log In", action: {
                    viewModel.validateAndLogin { success in
                        if success {
                            coordinator?.showMainApp()
                        }
                    }
                })
                .padding(.top, 20)
                .padding(.bottom, 30)
                signUpPrompt
                orSeparator
                socialLoginButtons
                    .padding(.bottom, 10)
                Spacer()
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Log In")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 30)
                .padding(.leading, 20)
            Spacer()
        }
    }
    
    private var signUpPrompt: some View {
        HStack {
            Text("Don't have an account?")
            Button(action: {
                coordinator?.showRegister()
            }) {
                Text("Sign Up")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
            .clipped()
        }
        .padding(.bottom, 20)
    }
    
    private var orSeparator: some View {
        HStack {
            line
            Text("OR")
                .foregroundColor(.gray)
            line
        }
    }
    
    private var line: some View {
        VStack { Divider().background(Color.gray) }
            .frame(height: 1)
            .padding(.horizontal, 10)
    }
    
    private var socialLoginButtons: some View {
        VStack(spacing: 12) {
            socialButton(imageName: "EmailImage", text: "Continue with Email")
            socialButton(imageName: "GoogleImage", text: "Continue with Google")
            socialButton(imageName: "AppleImage", text: "Continue with Apple")
        }
        .padding(.horizontal, 20)
    }
    
    private func socialButton(imageName: String, text: String) -> some View {
        Button(action: {
            // Handle social login action here
        }) {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 24, height: 21)
                    .scaledToFit()
                Spacer()
                Text(text)
                    .foregroundColor(.black)
                Spacer()
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .buttonStyle(BorderlessButtonStyle())
        .clipped()
    }
}

#Preview {
    LoginView(coordinator: nil)
}
