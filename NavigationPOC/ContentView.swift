//
//  ContentView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 06/07/2022.
//

import SwiftUI
import Introspect

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                GestureNavigationView()
                OverdragView()
                TapNavigationView()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .interactivePopNavigationGestures()
        .presentationContainer()
    }

}
