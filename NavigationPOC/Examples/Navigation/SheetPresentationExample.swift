//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct SheetPresentationExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .sheet)
            .sheet(isPresented: $isPresented) {
                NavigationPageView(type: .sheet)
            }
    }
}
