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
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            if !isValid {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
