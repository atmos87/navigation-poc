import SwiftUI

struct InteractiveNavigationGestureViewModifier: ViewModifier {
    
    enum Operation {
        case push(AnyView)
        case pop
    }
    
    @State private var delegate = NavigationDelegate()
    @State private var navigationController: UINavigationController?
    @State private var size: CGSize = .zero
    
    @GestureState private var active = false

    let operation: Operation

    func body(content: Content) -> some View {
        content
            .sizeReader { size in
                self.size = size
            }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($active) { value, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        let percent = percent(translation: gesture.translation)
                        delegate.change(percent: percent)
                    }
                    .onEnded { gesture in
//                        let velocity = CGSize(
//                            width:  gesture.predictedEndLocation.x - gesture.location.x,
//                            height: gesture.predictedEndLocation.y - gesture.location.y
//                        )

                        let percent = percent(translation: gesture.translation)
                        delegate.end(percent: percent, velocity: .zero/*velocity.width*/)

                        navigationController?.delegate = nil
                    }
            )
            .onChange(of: active) { active in
                if active && navigationController?.delegate == nil {
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
            .navigationViewStyle(.stack)
            .introspectNavigationController { controller in
                navigationController = controller
            }
    }
    
    private func percent(translation: CGSize) -> CGFloat {
        let width = size.width
        switch operation {
        case .push:
            return min(translation.width, 0) / (width * -1)
        case .pop:
            return max(translation.width, 0) / width
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
