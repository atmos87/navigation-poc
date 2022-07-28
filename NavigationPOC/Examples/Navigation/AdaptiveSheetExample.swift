//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct AdaptiveSheetExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .adaptiveSheet)
            .adaptiveSheet(isPresented: $isPresented, detents: [.medium(), .large()], smallestUndimmedDetentIdentifier: .large) {
                NavigationTypePageView(type: .adaptiveSheet)
            }
    }
}
