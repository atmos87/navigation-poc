//
//  Section.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.system(size: 20, weight: .medium, design: .default))
            content()
        }
    }
}
