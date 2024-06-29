//
//  CustomButtonView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 29.06.24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 20)
        }
    }
}
