//
//  ContentView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 06/07/2022.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Gesture Navigation".uppercased())
                        .font(.system(size: 20, weight: .medium, design: .default))
                    VStack(spacing: 20) {
                        Text("👇")
                            .font(.system(size: 50))
                            .background(
                                Circle()
                                    .foregroundColor(.white)
                            )
                        Text("Drag down quick to search")
                            .font(.system(size: 15))
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.systemGray4))
                    )

                    ZStack {
                        Text("Drag in from right")
                            .font(.system(size: 15))
                        Text("👈")
                            .font(.system(size: 50))
                            .background(
                                Circle()
                                    .foregroundColor(.white)
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.systemGray4))
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Overdrag".uppercased())
                        .font(.system(size: 20, weight: .medium, design: .default))
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
                
                VStack(alignment: .leading) {
                    Text("Tap Navigation".uppercased())
                        .font(.system(size: 20, weight: .medium, design: .default))
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
                            default:
                                NavigationTypeButton(isPresented: .constant(false), type: type)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

enum NavigationType: String, CaseIterable {
    case fullscreenCover = "Full screen sheet"
    case adaptiveSheet = "Modal Sheet"
    case zoom = "Zoom transition"
    case quickComment = "Quick comment"
    case push = "Native push"
    case sheet = "Native draw"
}

struct NavigationTypeBadge: View {
    let type: NavigationType
    
    var body: some View {
        VStack {
            Text("\(NavigationType.allCases.firstIndex(of: type) ?? 0 + 1)")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium, design: .default))
                .frame(maxWidth: .infinity)
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

struct NavigationTypeButton: View {
    @Binding var isPresented: Bool
    let type: NavigationType
    
    var body: some View {
        Button(action: { isPresented = true }) {
            NavigationTypeBadge(type: type)
        }
    }
}

struct NavigationTypeView: View {

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

struct SheetPresentationExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .sheet)
            .sheet(isPresented: $isPresented) {
                NavigationTypeView(type: .sheet)
            }
    }
}

struct FullscreenCoverExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .fullscreenCover)
            .fullScreenCover(isPresented: $isPresented) {
                NavigationTypeView(type: .fullscreenCover)
                    .overlay(
                        Button(action: { isPresented.toggle() }) {
                            Text("Tap close")
                                .font(.system(size: 26, weight: .medium, design: .default))
                                .foregroundColor(.white)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    )
            }
    }
}

struct AdaptiveSheetExample: View {
    @State private var isPresented = false

    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .adaptiveSheet)
            .adaptiveSheet(isPresented: $isPresented, detents: [.medium(), .large()], smallestUndimmedDetentIdentifier: .large) {
                NavigationTypeView(type: .adaptiveSheet)
            }
    }
}

struct PushExample: View {
    var body: some View {
        NavigationLink(
            destination: NavigationTypeView(type: .push)
//                .navigationBarBackButtonHidden(true)
        ) {
            NavigationTypeBadge(type: .push)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
