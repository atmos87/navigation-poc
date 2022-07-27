import SwiftUI

struct DragViewModifier: ViewModifier {
    
    @State private var size: CGSize = .zero
    @GestureState private var active = false
    
    enum Axis {
        case vertical
        case horizontal
    }
    
    enum Phase {
        case begun
        case change(percent: CGFloat)
        case end(percent: CGFloat, velocity: CGFloat)
    }
    
    let axis: Axis
    let invert: Bool
    let onPhaseChange: (Phase) -> Void
    
    func body(content: Content) -> some View {
        content
            .sizeReader { size in
                self.size = size
            }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($active) { _, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        let percent = percent(translation: gesture.translation)
                        onPhaseChange(.change(percent: percent))
                    }
                    .onEnded { gesture in
                        let percent = percent(translation: gesture.translation)
                        onPhaseChange(.end(percent: percent, velocity: 0))
                    }
            )
            .onChange(of: active) { active in
                if active {
                    onPhaseChange(.begun)
                }
            }
    }
    
    private func percent(translation: CGSize) -> CGFloat {
        let dimension: KeyPath<CGSize, CGFloat>

        switch axis {
        case .horizontal:
            dimension = \.width
        case .vertical:
            dimension = \.height
        }
        
        if invert {
            return min(translation[keyPath: dimension], 0) / (size[keyPath: dimension] * -1)
        } else {
            return max(translation[keyPath: dimension], 0) / size[keyPath: dimension]
        }
    }

}

extension View {
    
    func drag(axis: DragViewModifier.Axis, invert: Bool, onPhaseChange: @escaping (DragViewModifier.Phase) -> Void) -> some View {
        modifier(DragViewModifier(axis: axis, invert: invert, onPhaseChange: onPhaseChange))
    }
    
}
