//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct NavigationTypePageView: View {

    let type: NavigationType
    
    var body: some View {
        NavigationPageView(
            title: "\(NavigationType.allCases.firstIndex(of: type) ?? 0 + 1)",
            content: type.rawValue.uppercased()
        )
    }

}
