import Foundation
import SwiftUI

struct InteractivePresentationGestureViewModifier: ViewModifier {

    @State private var delegate = TransitioningDelegate()
    @State private var controller: UIViewController?
    
    let content: AnyView
    let completion: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .drag(axis: .vertical, invert: false, onPhaseChange: { phase in
                switch phase {
                case .begun:
                    present()
                case .change(let percent):
                    delegate.change(percent: percent)
                case .end(let percent, let velocity):
                    delegate.end(percent: percent, velocity: velocity)
                }
            })
            .introspectViewController { controller in
                self.controller = controller
            }
    }

    private func present() {
        delegate.begin()
        
        let host = UIHostingController(rootView: content)
        host.view.backgroundColor = .clear
        host.transitioningDelegate = delegate
        host.modalPresentationStyle = .custom
        
        controller?.present(host, animated: true, completion: completion)
    }

}

fileprivate class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var transition: UIPercentDrivenInteractiveTransition?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PullDownAnimationController(transitionType: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PullDownAnimationController(transitionType: .dismissing)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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

class PresentationController: UIPresentationController {
    lazy private var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black.withAlphaComponent(0.9)
        dimmingView.alpha = 0
        return dimmingView
    }()

    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView?.frame ?? .zero

        containerView?.insertSubview(dimmingView, belowSubview: presentedViewController.view)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if (!completed) {
            dimmingView.removeFromSuperview()
        }
    }

    override var shouldRemovePresentersView: Bool { return true }
}


extension View {

    func interactivePresentation<Content: View>(@ViewBuilder content: () -> Content, completion: (() -> Void)? = nil) -> some View {
        modifier(InteractivePresentationGestureViewModifier(
            content: AnyView(
                content()
            ),
            completion: completion
        ))
    }

}
