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
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(3.0)
                .padding(40)
                .background(Color.white.opacity(0.7))
                .cornerRadius(20)
        }
    }
}

