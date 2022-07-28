//
//  NavigationTypePageView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 28/07/2022.
//

import SwiftUI

struct NavigationPageView: View {
    let title: String
    let content: String
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 100, weight: .medium, design: .default))
            Text(content)
                .font(.system(size: 26, weight: .medium, design: .default))
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(30)
        .background(Color(.systemGray4))
    }
}
