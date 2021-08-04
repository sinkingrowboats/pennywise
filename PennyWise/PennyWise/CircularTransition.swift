//
//  CircularTransition.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/20/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/**
CircularTransition class for that fun circle transition that I do
 */

// Attribution: https://www.youtube.com/watch?v=B9sH_VxPPo4&t=751s How to Implement the circular transition I use
class CircularTransition: NSObject {
    var circle = UIView()
    var startingpoint = CGPoint.zero {
        didSet{
            circle.center = startingpoint
        }
    }
    
    var circleColor = UIColor.white
    
    var duration = 0.4
    
    enum CircularTransitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionMode: CircularTransitionMode = .present
}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if (transitionMode == .present) {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingpoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingpoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                containerView.addSubview(circle)
                
                presentedView.center = startingpoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                
                containerView.addSubview(presentedView)
                
                /// MARK: Animation
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                }, completion: {(success: Bool) in
                    if(!success) {
                        print("ERROR: CircularTransition not successful")
                    }
                        self.circle.removeFromSuperview()
                        transitionContext.completeTransition(success)
                })
            }
        }
        else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingpoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingpoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingpoint
                    returningView.alpha = 0
                    
                    if (self.transitionMode == .pop){
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                    
                }, completion: { (success: Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    
                    if(!success) {
                        print("ERROR: CircularTransition not successful")
                    }
                    transitionContext.completeTransition(success)
                })
            }
            
        }
    }
    
    func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
