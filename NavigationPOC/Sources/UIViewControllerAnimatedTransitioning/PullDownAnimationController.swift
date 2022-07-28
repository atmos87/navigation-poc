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

        switch transitionType {
        case .presenting:
            toView?.frame = inView.bounds
                .offsetBy(dx: 0, dy: -150)

            toView?.alpha = 0
            
            let fromViewSnapshot = fromView?.snapshotView(afterScreenUpdates: false)
            fromViewSnapshot?.layer.cornerRadius = 40
            fromViewSnapshot?.clipsToBounds = true
            fromViewSnapshot?.frame = fromView?.frame ?? .zero
            fromViewSnapshot?.tag = 99

            inView.insertSubview(fromViewSnapshot!, at: 0)
            fromView?.isHidden = true

            if let toView = toView {
                inView.addSubview(toView)
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.frame = inView.bounds
                toView?.alpha = 1
                fromViewSnapshot?.frame.origin.y += 150
                
            }, completion: { _ in
                if transitionContext.transitionWasCancelled {
                    fromView?.isHidden = false
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            let toViewSnapshot = inView.viewWithTag(99)
            
            toView?.isHidden = true
            toView?.frame = inView.bounds

            if let toView = toView, let fromView = fromView {
                inView.insertSubview(toView, belowSubview: fromView)
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toViewSnapshot?.frame = toView?.frame ?? .zero

                fromView?.alpha = 0
                fromView?.frame.origin.y = -150
            }, completion: { _ in
                if !transitionContext.transitionWasCancelled {
                    toViewSnapshot?.removeFromSuperview()
                    toView?.isHidden = false
                }

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

}
