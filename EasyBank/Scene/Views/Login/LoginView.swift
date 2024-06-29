//
//  LoginView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true

    var body: some View {
        VStack {
            header
            CustomTextField(placeholder: "Your Email", text: $email, isValid: isEmailValid, validationMessage: "This field is required")
            CustomSecureField(placeholder: "Password", text: $password, isValid: isPasswordValid, validationMessage: "Password is required")
            loginButton
            signUpPrompt
            orSeparator
            socialLoginButtons
            
        }
        
    }
    
    private var header: some View {
        Text("Log In")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }

    private var loginButton: some View {
        CustomButton(title: "Log In", action: validateAndLogin)
            .padding(.top, 20)
            .padding(.bottom, 30)
    }
    
    private func validateAndLogin() {
        self.isEmailValid = !self.email.isEmpty
        self.isPasswordValid = !self.password.isEmpty
        if self.isEmailValid && self.isPasswordValid {
            // Handle login logic here
        }
    }
    
    private var signUpPrompt: some View {
        HStack {
            Text("Don't have an account?")
            Button(action: {
                // Handle sign up action here
            }) {
                Text("Sign Up")
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom, 20)
        .padding(.top, 10)
    }
    
    private var orSeparator: some View {
        HStack {
            line
            Text("OR")
                .foregroundColor(.gray)
            line
        }
        .padding(.vertical, 10)
    }
    
    private var line: some View {
        VStack { Divider().background(Color.gray) }
            .frame(height: 1)
            .padding(.horizontal, 10)
    }

    private var socialLoginButtons: some View {
        VStack(spacing: 16) {
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
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 25)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
}

#Preview {
    LoginView()
}
