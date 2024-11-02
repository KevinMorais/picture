//
//  PresentTodayDetailsAnimatedTransitioning.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

final class PresentTodayDetailsAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let sourceAnimatedCard = transitionContext.viewController(forKey: .from) as? SourceAnimatedCardProtocol,
              let destinationAnimatedCard = transitionContext.viewController(forKey: .to) as? DestinationAnimatedCardProtocol,
              let sourceAnimatedView = sourceAnimatedCard.sourceAnimationView,
              let snapshotSourceView = sourceAnimatedView.snapshotView(afterScreenUpdates: false),
              let sourceFrameOnScreen = sourceAnimatedView.superview?.convert(sourceAnimatedView.frame, to: nil) else {
            transitionContext.completeTransition(true)
            return
        }

        snapshotSourceView.frame = sourceFrameOnScreen

        transitionContext.containerView.addSubview(destinationAnimatedCard.view)
        transitionContext.containerView.addSubview(snapshotSourceView)

        destinationAnimatedCard.view.alpha = 0

        let firstAnimation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
            sourceAnimatedCard.view.subviews.forEach { $0.alpha = 0 }
            destinationAnimatedCard.view.frame = transitionContext.finalFrame(for: destinationAnimatedCard)
            destinationAnimatedCard.view.layoutIfNeeded()
            let destinationFrame = transitionContext.containerView.convert(destinationAnimatedCard.destinationAnimationView.frame, from: destinationAnimatedCard.view)
            snapshotSourceView.frame = destinationFrame
        }

        let secondAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            destinationAnimatedCard.view.alpha = 1
        }

        secondAnimation.addCompletion { position in
            sourceAnimatedCard.view.subviews.forEach { $0.alpha = 1 }
            destinationAnimatedCard.view.alpha = 1

            UIView.animate(withDuration: 0.2) {
                snapshotSourceView.alpha = 0
            } completion: { _ in
                snapshotSourceView.removeFromSuperview()
            }

            transitionContext.completeTransition(position == .end)
        }

        firstAnimation.addCompletion { _ in

            secondAnimation.startAnimation()
        }

        firstAnimation.startAnimation()
    }
}
