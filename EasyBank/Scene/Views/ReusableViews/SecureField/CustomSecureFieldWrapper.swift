//
//  CustomSecureFieldWrapper.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import SwiftUI

struct CustomSecureFieldWrapper: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isValid: Bool

    func makeUIView(context: Context) -> CustomSecureUITextField {
        let textField = CustomSecureUITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.delegate = context.coordinator
        textField.isValid = isValid
        return textField
    }

    func updateUIView(_ uiView: CustomSecureUITextField, context: Context) {
        uiView.text = text
        uiView.isValid = isValid
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomSecureFieldWrapper

        init(_ parent: CustomSecureFieldWrapper) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

