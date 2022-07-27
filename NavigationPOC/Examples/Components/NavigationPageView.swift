//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct NavigationPageView: View {

    let type: NavigationType
    
    var body: some View {
        ZStack {
            Text("\(NavigationType.allCases.firstIndex(of: type) ?? 0 + 1)")
                .font(.system(size: 100, weight: .medium, design: .default))
            Text(type.rawValue.uppercased())
                .font(.system(size: 26, weight: .medium, design: .default))
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(30)
        .background(Color(.systemGray4))
    }

}
