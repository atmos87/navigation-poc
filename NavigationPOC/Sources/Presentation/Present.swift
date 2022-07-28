//
//  Present.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import Foundation
import SwiftUI

struct PresentViewModifier<PresentationContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let presentation: () -> PresentationContent

    func body(content: Content) -> some View {
        content
            .preference(
                key: PresentationPreferenceKey.self,
                value: PresentationModel(
                    isPresented: $isPresented,
                    content: AnyView(
                        presentation()
                    )
                )
            )
            .transformPreference(PresentationPreferenceKey.self) { value in
                if !isPresented {
                    value = nil
                }
            }
    }

}

extension View {
    func present<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(PresentViewModifier(isPresented: isPresented, presentation: content))
    }
}

struct PresentationModel {
    @Binding var isPresented: Bool
    let content: AnyView
}

struct PresentationPreferenceKey: PreferenceKey {
    typealias Value = PresentationModel?
    static var defaultValue: Value = nil

    static func reduce(value: inout Value, nextValue: () -> Value) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

struct PresentViewContainerModifier: ViewModifier {
    @State private var offset = CGSize.zero
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlayPreferenceValue(PresentationPreferenceKey.self) { model in
                model?
                    .content
                    .animation(.spring(), value: offset)
                    .offset(x: offset.width, y: offset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 100 || abs(offset.height) > 100 {
                                    model?.isPresented = false
                                    offset = .zero
                                } else {
                                    offset = .zero
                                }
                            }
                    )
            }
    }
}

extension View {
    func presentationContainer() -> some View {
        modifier(PresentViewContainerModifier())
    }
}
