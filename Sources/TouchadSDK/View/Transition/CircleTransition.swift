//
//  CircleTransition.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2021/01/28.
//

import UIKit

class CircleTransition: NSObject {
    
    enum TransitionMode {
        case present, dismiss, pop
    }
 
    var circle: UIView!
    var circleColor: UIColor = .white
    var duration = 0.3
    var transitionMode: TransitionMode = .present
    var startPoint: CGPoint = .zero {
        didSet {
            circle?.center = startPoint
        }
    }
}

extension CircleTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration // 애니메이션 duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView // 애니메이션이 발생하여야 할 경우에 호출됩니다. present, dismiss 등
        
        switch transitionMode {
        case .present:
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                circle.frame = frameForCircle(center: viewCenter, size: viewSize, startPoint: startPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                containerView.addSubview(circle)
                
                presentedView.center = startPoint
                presentedView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let self = self else { return }
                    
                    self.circle.transform = CGAffineTransform.identity
                    
                    presentedView.center = viewCenter
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                }) { success in
                    transitionContext.completeTransition(success)
                }
            }
        default:
            let transitionModeKey: UITransitionContextViewKey = (transitionMode == .pop) ? .to : .from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(center: viewCenter, size: viewSize, startPoint: startPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startPoint
                
                UIView.animate(withDuration: duration, animations: { [weak self] in
                    guard let self = self else { return }
                    
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                }) { [weak self] success in
                    guard let self = self else { return }
                    
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
    
    private func frameForCircle(center: CGPoint, size: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, size.width - startPoint.x)
        let yLength = fmax(startPoint.y, size.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}



class AlphaTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionMode {
        case present, dismiss, pop
    }
 
    var duration = 0.5
    var transitionMode: TransitionMode = .present
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch transitionMode {
        case .present:
            if let presentedView = transitionContext.view(forKey: .to) {
                
                let container = transitionContext.containerView
                
                presentedView.alpha = 0.0
                container.addSubview(presentedView)
                
                UIView.animate(withDuration: 0.5, animations: {
                    presentedView.alpha = 1.0
                }) { (isFinish) in
                    
                    transitionContext.completeTransition(isFinish)
                }
                
            }
        default:
            let transitionModeKey: UITransitionContextViewKey = (transitionMode == .pop) ? .to : .from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                
                let container = transitionContext.containerView
                
                returningView.alpha = 1.0
                container.addSubview(returningView)
                
                UIView.animate(withDuration: 0.5, animations: {
                    returningView.alpha = 0.0
                }) { (isFinish) in
                    returningView.removeFromSuperview()
                    transitionContext.completeTransition(isFinish)
                }
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
