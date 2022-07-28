//
//  View+Helpers.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 27/07/2022.
//

import Foundation
import SwiftUI

struct ContentFrameReaderPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect { return CGRect() }
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

extension View {

    func frameReader(in coordinates: CoordinateSpace = .local, frame: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ContentFrameReaderPreferenceKey.self, value: geometry.frame(in: coordinates))
                    .onPreferenceChange(ContentFrameReaderPreferenceKey.self) { newValue in
                        DispatchQueue.main.async {
                            frame(newValue)
                        }
                    }
            }
            .hidden()
        )
    }
    
}
