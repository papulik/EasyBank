//
//  CustomSecureFieldView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 29.06.24.
//

import SwiftUI

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var isValid: Bool
    var validationMessage: String
    @State private var isSecure: Bool = true

    var body: some View {
        VStack {
            textFieldWithToggle
            validationText
        }
    }

    private var textFieldWithToggle: some View {
        ZStack(alignment: .trailing) {
            if isSecure {
                secureField
            } else {
                textField
            }
            toggleButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    private var secureField: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(5.0)
            .overlay(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )
    }

    private var textField: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(5.0)
            .overlay(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )
    }

    private var toggleButton: some View {
        Button(action: {
            isSecure.toggle()
        }) {
            Image(systemName: self.isSecure ? "eye.slash.fill" : "eye.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 30)
                .padding(.top, 10)
        }
    }

    private var validationText: some View {
        if !isValid {
            return AnyView(
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}
