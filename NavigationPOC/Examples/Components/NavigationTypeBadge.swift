//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct NavigationTypeBadge: View {
    let type: NavigationType
    
    var body: some View {
        VStack {
            Text("\(NavigationType.allCases.firstIndex(of: type) ?? 0 + 1)")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(.systemGray4))
                )
            Text(type.rawValue)
                .font(.system(size: 15))
        }
    }
}
