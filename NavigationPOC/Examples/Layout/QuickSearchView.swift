import SwiftUI

struct QuickSearchView: View {
    
    @Binding var showKeyboard: Bool
    @Environment(\.presentationMode) var presentation
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Quick Search".uppercased(), text: $text, onCommit: {
                showKeyboard = false
            })
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.secondary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .foregroundColor(.white)
            )
            .padding()
                .introspectTextField { field in
                    if showKeyboard {
                        field.becomeFirstResponder()
                    } else {
                        field.resignFirstResponder()
                    }
                }
            Spacer()
        }
        .background(
            Color
                .clear
                .contentShape(Rectangle())
                .onTapGesture {
                    showKeyboard = false
                    presentation.wrappedValue.dismiss()
                }
        )
    }

}
