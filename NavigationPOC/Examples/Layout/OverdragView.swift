//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct OverdragView: View {
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
            }
        }
    }
}
