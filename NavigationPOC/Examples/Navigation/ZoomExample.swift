//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct ZoomExample: View {
    @Namespace var zoom
    @State private var isPresented = false

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isPresented = true
            }
        }) {
            if !isPresented {
                NavigationTypeBadge(type: .zoom)
                    .matchedGeometryEffect(id: "zoom", in: zoom)
            }
        }
        .present(isPresented: $isPresented.animation(.spring())) {
            NavigationTypePageView(type: .zoom)
                .matchedGeometryEffect(id: "zoom", in: zoom)
        }
    }
}
