//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct NavigationTypeButton: View {
    @Binding var isPresented: Bool
    let type: NavigationType
    
    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            NavigationTypeBadge(type: type)
        }
    }
}
