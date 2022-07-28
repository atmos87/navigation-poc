//
//  SwiftUIView.swift
//  NavigationPOC
//
//  Created by Dino Constantinou on 26/07/2022.
//

import SwiftUI

struct QuickCommentExample: View {
    @State private var text = ""
    @State private var isPresented = false
    
    var body: some View {
        NavigationTypeButton(isPresented: $isPresented, type: .quickComment)
            .present(isPresented: $isPresented) {
                TextField("Quick Comment", text: $text, onCommit: { self.isPresented = false })
                    .introspectTextField { field in
                        if isPresented {
                            field.becomeFirstResponder()
                        } else {
                            field.resignFirstResponder()
                        }
                    }
                    .padding()
                    .background(
                        Capsule()
                            .foregroundColor(Color(.systemGray5))
                    )
                    .padding()
                    .background(
                        Color.white
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
    }
}
