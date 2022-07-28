//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct FullscreenCoverExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .fullscreenCover)
            .fullScreenCover(isPresented: $isPresented) {
                NavigationTypePageView(type: .fullscreenCover)
                    .overlay(
                        Button(action: { isPresented.toggle() }) {
                            Text("Tap close")
                                .font(.system(size: 26, weight: .medium, design: .default))
                                .foregroundColor(.white)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    )
            }
    }
}
