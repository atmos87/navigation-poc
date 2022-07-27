import UIKit

class PullDownAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case presenting
        case dismissing
    }

    let transitionType: TransitionType

    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        var frame = inView.bounds

        switch transitionType {
        case .presenting:
            toView?.frame = frame
                .offsetBy(dx: 0, dy: -50)

            toView?.alpha = 0

            if let toView = toView {
                inView.addSubview(toView)
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.frame = inView.bounds
                toView?.alpha = 1
                
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            toView?.frame = frame
            if let toView = toView, let fromView = fromView {
                inView.insertSubview(toView, belowSubview: fromView)
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                frame.origin.y = -50
                fromView?.alpha = 0
                fromView?.frame = frame
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

}
