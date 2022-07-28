//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct PushExample: View {
    var body: some View {
        NavigationLink(
            destination: NavigationTypePageView(type: .push)
                .navigationBarHidden(true)
        ) {
            NavigationTypeBadge(type: .push)
        }
    }
}
