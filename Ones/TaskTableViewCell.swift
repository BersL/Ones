//
//  TaskTableViewCell.swift
//  Ones
//
//  Created by Bers on lineLeft/2/7.
//  Copyright (c) 20lineLeft年 Bers. All rights reserved.
//

import UIKit
import QuartzCore

protocol taskTableViewCellDelegate {
    func cellFinishStateChanged(finished:Bool , indexPath: NSIndexPath)
}

let deleteLineColor = UIColor(white: 0.4, alpha: 0.5).CGColor
let deleteLineWidth = CGFloat(1.3)
let deleteLineAnimationDuration = 0.4
let lineLeft : CGFloat = 15
let lineRight : CGFloat = UIScreen.mainScreen().bounds.size.width - 15

class TaskTableViewCell: UITableViewCell, UIGestureRecognizerDelegate {
    
    var line : UIImageView!
    var delegate : taskTableViewCellDelegate?
    var finishedState : Bool = false
    var rightPan : Bool = false
    var startPoint, endPoint : CGPoint?
    var animationLayerLeft , animationLayerRight : CAShapeLayer?
    var panGesture  : UIPanGestureRecognizer!
    var indexPath : NSIndexPath!
    
    func finishStateExchange (sender : UIPanGestureRecognizer) {
        if !finishedState {
            if sender.state == UIGestureRecognizerState.Began{
                startPoint = CGPoint(x:sender.locationInView(self).x, y: 30)
                if startPoint?.x < lineLeft {
                    startPoint = CGPoint(x: lineLeft, y: 30)
                }else if startPoint?.x > lineRight {
                    startPoint = CGPoint(x: lineRight, y: 30)
                }
            }else if sender.state == UIGestureRecognizerState.Changed {
                endPoint = CGPoint(x: sender.locationInView(self).x, y: 30)
                if endPoint?.x > lineRight {
                    endPoint = CGPoint(x: lineRight, y: 30)
                }
                if endPoint?.x >= lineLeft{
                    self.setNeedsDisplay()
                }
            }else if sender.state == UIGestureRecognizerState.Ended {
                let offsetX = sender.locationInView(self).x
                let offset = (startPoint?.x)! - offsetX
                rightPan = (offset>0)
                if abs(offset) >= self.frame.size.width / 4 {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.textLabel?.alpha = 0.3
                        return
                    })
                    setupDrawingPath(true)
                    finishedState = true
                    startAnimation()
                }else{
                    setupDrawingPath(false)
                    finishedState = false
                }
            }
        }else{
            if sender.state == UIGestureRecognizerState.Began {
                startPoint = CGPoint(x:sender.locationInView(self).x, y: 30)
            }else if sender.state == UIGestureRecognizerState.Changed {
                endPoint = CGPoint(x: sender.locationInView(self).x, y: 30)
            }else if sender.state == UIGestureRecognizerState.Ended {
                let offsetX = sender.locationInView(self).x
                let offset = (startPoint?.x)! - offsetX
                rightPan = (offset>0)

                if abs(offset) >= self.frame.size.width / 4{
                    
                    startPoint = CGPoint(x: lineLeft, y: 30)
                    endPoint = CGPoint(x: lineRight, y: 30)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.textLabel?.alpha = 1.0
                        return
                    })
                    finishedState = false
                    setupDrawingPath(false)
                    delegate?.cellFinishStateChanged(finishedState, indexPath: indexPath)
                }
            }
        }
    }
    
    func setupDrawingPath (expand:Bool) {
        animationLayerLeft?.removeFromSuperlayer()
        animationLayerLeft = nil
        animationLayerRight?.removeFromSuperlayer()
        animationLayerRight = nil
        
        
        if expand {
            animationLayerLeft = CAShapeLayer()
            animationLayerLeft?.frame = self.bounds
            animationLayerLeft?.strokeColor = deleteLineColor
            animationLayerLeft?.fillColor = UIColor.clearColor().CGColor
            animationLayerLeft?.lineJoin = kCALineJoinBevel
            animationLayerLeft?.lineWidth = deleteLineWidth
            
            let leftPath = UIBezierPath()
            leftPath.moveToPoint(rightPan ? endPoint! : startPoint!)
            leftPath.addLineToPoint(CGPointMake(lineLeft, 30))
            animationLayerLeft?.path = leftPath.CGPath
            self.contentView.layer.addSublayer(animationLayerLeft)
            
            animationLayerRight = CAShapeLayer()
            animationLayerRight?.frame = self.bounds
            animationLayerRight?.strokeColor = deleteLineColor
            animationLayerRight?.fillColor = UIColor.clearColor().CGColor
            animationLayerRight?.lineJoin = kCALineJoinBevel
            animationLayerRight?.lineWidth = deleteLineWidth
            
            let rightPath = UIBezierPath()
            rightPath.moveToPoint(rightPan ? startPoint! : endPoint!)
            rightPath.addLineToPoint(CGPointMake(lineRight, 30))
            animationLayerRight?.path = rightPath.CGPath
            self.contentView.layer.addSublayer(animationLayerRight)
        }else{
            startPoint = nil ; endPoint = nil
            setNeedsDisplay()
        }
    }
    
    func startAnimation () {
        animationLayerRight?.removeAllAnimations()
        animationLayerLeft?.removeAllAnimations()
        
        let leftAnimation = CABasicAnimation(keyPath: "strokeEnd")
        leftAnimation.duration = deleteLineAnimationDuration
        leftAnimation.fromValue = NSNumber(double: 0.0)
        leftAnimation.toValue = NSNumber(double: 1.0)
        leftAnimation.delegate = self
        self.animationLayerLeft?.addAnimation(leftAnimation, forKey: "strokeEnd")
        
        let rightAnimation = CABasicAnimation(keyPath: "strokeEnd")
        rightAnimation.duration = deleteLineAnimationDuration
        rightAnimation.fromValue = NSNumber(double: 0.0)
        rightAnimation.toValue =  NSNumber(double: 1.0)
        rightAnimation.delegate = self
        self.animationLayerRight?.addAnimation(rightAnimation, forKey: "strokeEnd")

    }
    
    override func animationDidStart(anim: CAAnimation!) {
        panGesture.enabled = false
    }
    
    var cnt = 0;
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        panGesture.enabled = true
        if cnt == 0{
            ++cnt
        }else{
            delegate?.cellFinishStateChanged(finishedState, indexPath: indexPath)
            animationLayerLeft?.removeFromSuperlayer()
            animationLayerLeft = nil
            animationLayerRight?.removeFromSuperlayer()
            animationLayerRight = nil
            startPoint = CGPointMake(lineLeft, 30)
            endPoint = CGPointMake(lineRight, 30)
            self.setNeedsDisplay()
            cnt = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.textAlignment = NSTextAlignment.Center
        
        panGesture = UIPanGestureRecognizer(target: self, action: "finishStateExchange:")
//        panGesture.enabled = false
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchesBegan")
        super.touchesBegan(touches, withEvent: event)
    }
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextAddRect(context, CGRectMake(5, 5, self.frame.size.width - 10, 50))
        CGContextSetStrokeColorWithColor(context, UIColor(white: 0.3, alpha: 0.2).CGColor)
        CGContextSetLineWidth(context, 0.8)
        CGContextStrokePath(context)
        
        if let startPoint = self.startPoint{
            if let endPoint = self.endPoint{
                CGContextBeginPath(context)
                CGContextSetLineWidth(context, deleteLineWidth)
                CGContextSetStrokeColorWithColor(context, deleteLineColor)
                
                CGContextMoveToPoint(context, startPoint.x, startPoint.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
                CGContextStrokePath(context)
            }
        }else if finishedState {
            let startPoint = CGPointMake(lineLeft, 30)
            let endPoint = CGPointMake(lineRight, 30)
            CGContextBeginPath(context)
            CGContextSetLineWidth(context, deleteLineWidth)
            CGContextSetStrokeColorWithColor(context, deleteLineColor)
            
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
            CGContextStrokePath(context)

        }
                
    }

}
