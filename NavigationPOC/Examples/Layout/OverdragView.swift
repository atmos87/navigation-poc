//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct OverdragView: View {

    struct ScrollViewState: Equatable {
        var size: CGSize = .zero
        var content: CGRect = .zero
    }
    
    @State private var state = ScrollViewState()
    @State private var didOvershoot = false
    @State private var navigationController: UINavigationController?
    
    var body: some View {
        SectionView(title: "Overdrag") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<10) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.systemGray4))
                            .frame(width: 100, height: 100)
                    }
                }
                .background(
                    Text("See more")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: 80, y: 0)
                )
                .frameReader(in: .named("scroll")) { frame in
                    self.state.content = frame
                }
            }
            .frameReader { frame in
                self.state.size = frame.size
            }
            .coordinateSpace(name: "scroll")
        }
        .onChange(of: state) { state in
            let target = -(state.content.size.width - state.size.width)
            let overshoot = target - state.content.origin.x
            
            didOvershoot = overshoot > 80
        }
        .onChange(of: didOvershoot) { newValue in
            if newValue {
                push()
            }
        }
        .introspectNavigationController { controller in
            navigationController = controller
        }
    }

    func push() {
        navigationController?.pushViewController(
            UIHostingController(
                rootView: NavigationPageView(
                    title: "5",
                    content: "Native Push".uppercased()
                )
                .overlay(
                    Text("Drag to close")
                        .font(.system(size: 26, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                )
                .navigationBarHidden(true)
            ),
            animated: true
        )
    }
    
}
