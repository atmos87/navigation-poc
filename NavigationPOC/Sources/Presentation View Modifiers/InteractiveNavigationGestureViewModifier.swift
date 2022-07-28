import SwiftUI

struct InteractiveNavigationGestureViewModifier: ViewModifier {
    
    enum Operation {
        case push(AnyView)
        case pop
    }
    
    @State private var delegate = NavigationDelegate()
    @State private var navigationController: UINavigationController?

    let operation: Operation
    
    var invert: Bool {
        switch operation {
        case .push:
            return true
        case .pop:
            return false
        }
    }

    func body(content: Content) -> some View {
        content
            .drag(axis: .horizontal, invert: invert, onPhaseChange: { phase in
                switch phase {
                case .begun:
                    begin()
                case .change(let percent):
                    delegate.change(percent: percent)
                case .end(let percent, let velocity):
                    delegate.end(percent: percent, velocity: velocity)
                    navigationController?.delegate = nil
                }
            })
            .navigationViewStyle(.stack)
            .introspectNavigationController { controller in
                navigationController = controller
            }
    }
    
    private func begin() {
        guard navigationController?.delegate == nil else {
            return
        }

        delegate.begin()
        navigationController?.delegate = delegate

        switch operation {
        case .push(let view):
            navigationController?.pushViewController(UIHostingController(rootView: view), animated: true)
        case .pop:
            navigationController?.popViewController(animated: true)
        }
    }

}

extension InteractiveNavigationGestureViewModifier {
    
    fileprivate class NavigationDelegate: NSObject, UINavigationControllerDelegate {
        private var transition: UIPercentDrivenInteractiveTransition?
        
        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            switch operation {
            case .push:
                return SlidePushAnimationTransition()
            case .pop:
                return SlidePopAnimationTransition()
            default:
                return nil
            }
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
            if percent > 0.5 || abs(velocity) > 100 {
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
    
    func interactivePopNavigationGestures() -> some View {
        modifier(InteractiveNavigationGestureViewModifier(operation: .pop))
    }
    
    func interactivePushNavigationGesture<Content: View>(destination: Content) -> some View {
        modifier(InteractiveNavigationGestureViewModifier(
            operation: .push(
                AnyView(
                    destination
                )
            )
        ))
    }

}
