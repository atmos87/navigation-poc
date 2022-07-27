import SwiftUI

struct InteractiveNavigationGestureViewModifier: ViewModifier {
    
    @State private var delegate = NavigationDelegate()
    @State private var navigationController: UINavigationController?
    
    @GestureState private var translation: CGSize = .zero
    @GestureState private var active = false

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .navigationViewStyle(.stack)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            state = value.translation
                        }
                        .updating($active) { value, state, _ in
                            state = true
                        }
                        .onChanged { gesture in
                            let percent = percent(proxy: proxy)
                            delegate.change(percent: percent)
                        }
                        .onEnded { gesture in
                            let velocity = CGSize(
                                width:  gesture.predictedEndLocation.x - gesture.location.x,
                                height: gesture.predictedEndLocation.y - gesture.location.y
                            )

                            let percent = percent(proxy: proxy)
                            delegate.end(percent: percent, velocity: velocity.width)

                            navigationController?.delegate = nil
                        }
                )
                .onChange(of: active) { active in
                    if active {
                        delegate.begin()
                        navigationController?.delegate = delegate
                        navigationController?.popViewController(animated: true)
                    }
                }
                .introspectNavigationController { controller in
                    navigationController = controller
                }
        }
    }
    
    private func percent(proxy: GeometryProxy) -> CGFloat {
        let width = proxy.frame(in: .global).width
        let percent = max(translation.width, 0) / width
        
        return percent
    }

}

extension InteractiveNavigationGestureViewModifier {
    
    fileprivate class NavigationDelegate: NSObject, UINavigationControllerDelegate {
        private var transition: UIPercentDrivenInteractiveTransition?
        
        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            SlideAnimationTransition()
        }

        func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            transition
        }

        func begin() {
            transition = UIPercentDrivenInteractiveTransition()
            transition?.completionCurve = .easeOut
        }
        
        func change(percent: CGFloat) {
            transition?.update(percent)
        }
        
        func end(percent: CGFloat, velocity: CGFloat) {
            if percent > 0.5 || velocity > 100 {
                transition?.finish()
            } else {
                transition?.cancel()
            }
            
            transition = nil
        }
        
        func cancel() {
            transition?.cancel()
            transition = nil
        }
    }

}

extension View {
    
    func interactiveNavigationGestures() -> some View {
        modifier(InteractiveNavigationGestureViewModifier())
    }
    
}
