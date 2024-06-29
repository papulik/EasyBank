//
//  RegisterView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 28.06.24.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isRepeatPasswordValid: Bool = true

    var body: some View {
        VStack {
            header
            CustomTextField(placeholder: "Your Email", text: $email, isValid: isEmailValid, validationMessage: "This field is required")
            CustomSecureField(placeholder: "Password", text: $password, isValid: isPasswordValid, validationMessage: "Password is required")
            CustomSecureField(placeholder: "Repeat Password", text: $repeatPassword, isValid: isRepeatPasswordValid, validationMessage: "Passwords do not match")
            signInPrompt
            Spacer()
            termsAndPrivacy
            CustomButton(title: "Register", action: validateAndRegister)
                .padding(.bottom, 25)
        }
    }
    
    private var header: some View {
        Text("Registration Form")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.top, 40)
    }
    
    private func validateAndRegister() {
        self.isEmailValid = !self.email.isEmpty
        self.isPasswordValid = !self.password.isEmpty
        self.isRepeatPasswordValid = self.password == self.repeatPassword
        if self.isEmailValid && self.isPasswordValid && self.isRepeatPasswordValid {
            
        }
    }
    
    private var signInPrompt: some View {
        HStack {
            Text("Already have an account?")
            Button(action: {
                
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
               
            }) {
                Text("Terms of Use")
                    .foregroundColor(.blue)
            }
            Text("and")
            Button(action: {
                
            }) {
                Text("Privacy Policy")
                    .foregroundColor(.blue)
            }
        }
        .font(.caption)
    }
}

#Preview {
    RegisterView()
}
