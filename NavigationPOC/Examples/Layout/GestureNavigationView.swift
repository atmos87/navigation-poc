//
//  GestureSection.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct GestureNavigationView: View {
    
    @State private var showKeyboard = false
    
    var body: some View {
        SectionView(title: "Gesture Navigation") {
            VStack(spacing: 20) {
                Text("👇")
                    .font(.system(size: 50))
                    .background(
                        Circle()
                            .foregroundColor(.white)
                    )
                Text("Drag down quick to search")
                    .font(.system(size: 15))
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGray4))
            )
            .interactivePresentation {
                QuickSearchView(showKeyboard: $showKeyboard)
            } completion: {
                showKeyboard =  true
            }

            ZStack {
                Text("Drag in from right")
                    .font(.system(size: 15))
                Text("👈")
                    .font(.system(size: 50))
                    .background(
                        Circle()
                            .foregroundColor(.white)
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGray4))
            )
            .interactivePushNavigationGesture(
                destination: NavigationPageView(type: .push)
                    .navigationBarHidden(true)
            )
        }
    }

}
