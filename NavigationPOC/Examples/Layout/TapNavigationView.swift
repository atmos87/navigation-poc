//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct TapNavigationView: View {
    
    var body: some View {
        SectionView(title: "Tap Navigation") {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 0, maximum: 1000), spacing: 12, alignment: .leading), count: 3), alignment: .center, spacing: 30) {
                ForEach(NavigationType.allCases, id: \.self) { type in
                    switch type {
                    case .sheet:
                        SheetPresentationExample()
                    case .fullscreenCover:
                        FullscreenCoverExample()
                    case .adaptiveSheet:
                        AdaptiveSheetExample()
                    case .push:
                        PushExample()
                    case .zoom:
                        ZoomExample()
                    case .quickComment:
                        QuickCommentExample()
                    }
                }
            }
        }
    }

}
