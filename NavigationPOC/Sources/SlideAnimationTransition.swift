import UIKit

final class SlideAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
              let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else { return }
        
        let containerView = transitionContext.containerView
        let width = containerView.frame.width
        
        var offsetLeft = fromView.frame
        offsetLeft.origin.x = width
        
        var offscreenRight = toView.frame
        offscreenRight.origin.x = -width / 3.33
        
        toView.frame = offscreenRight
        
        fromView.layer.shadowRadius = 20.0
        fromView.layer.shadowOpacity = 0.3
        toView.layer.opacity = 0.9
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                toView.frame = (fromView.frame)
                fromView.frame = offsetLeft
            
                toView.layer.opacity = 1.0
                fromView.layer.shadowOpacity = 0.1
            
                },
            completion: { finished in
                toView.layer.opacity = 1.0
                toView.layer.shadowOpacity = 0
                fromView.layer.opacity = 1.0
                fromView.layer.shadowOpacity = 0

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

}
