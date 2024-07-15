//
//  CustomSpinnerView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 07.07.24.
//

import SwiftUI

struct CustomSpinnerView: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(3.0)
                .padding(30)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
        }
    }
}
