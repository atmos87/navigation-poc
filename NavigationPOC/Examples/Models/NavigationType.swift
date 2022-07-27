//
//  Examples.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

enum NavigationType: String, CaseIterable {
    case fullscreenCover = "Full screen"
    case adaptiveSheet = "Modal Sheet"
    case zoom = "Zoom transition"
    case quickComment = "Quick comment"
    case push = "Native push"
    case sheet = "Native draw"
}
