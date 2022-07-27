import SwiftUI

struct QuickSearchView: View {
    
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Quick Search".uppercased(), text: $text)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .foregroundColor(.white)
                )
                .padding()
//                .introspectTextField { field in
//                    field.becomeFirstResponder()
//                }
            Spacer()
        }
    }

}
