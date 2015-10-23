//
//  PopupView.swift
//  Ones
//
//  Created by Bers on 15/3/12.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class PopupView: UIView {
    
    var arrowHeight : CGFloat = 10
    var showPoint : CGPoint!
    let bkgColor = UIColor(white: 0.1, alpha: 0.7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {

        UIColor.clearColor().set()
        var borderPath = UIBezierPath()
        borderPath.lineCapStyle = kCGLineCapRound
        borderPath.lineJoinStyle = kCGLineJoinRound
        
        borderPath.moveToPoint(showPoint)
        var triangleLeft = showPoint
        triangleLeft.x -= (arrowHeight / 2 + 3) ; triangleLeft.y += arrowHeight
        var triangleRight = triangleLeft
        triangleRight.x += (arrowHeight + 2 * 3)
        var upperLeft = triangleLeft
        upperLeft.x = self.frame.origin.x
        var lowerLeft = upperLeft
        lowerLeft.y = self.frame.origin.y + self.frame.size.height
        var upperRight = upperLeft
        upperRight.x = self.frame.origin.x + self.frame.size.width
        var lowerRight = lowerLeft
        lowerRight.x = upperRight.x
        
        borderPath.addCurveToPoint(triangleLeft, controlPoint1: CGPoint(x: showPoint.x - 2, y: triangleLeft.y), controlPoint2: triangleLeft)
        borderPath.addLineToPoint(upperLeft)
        borderPath.addLineToPoint(lowerLeft)
        borderPath.addLineToPoint(lowerRight)
        borderPath.addLineToPoint(upperRight)
        borderPath.addLineToPoint(triangleRight)
        borderPath.addCurveToPoint(showPoint, controlPoint1: CGPoint(x: showPoint.x + 2, y: triangleLeft.y), controlPoint2: showPoint)
        bkgColor.setFill()
        borderPath.fill()
        
        UIColor.whiteColor().set()
        let separator = UIBezierPath()
        separator.lineWidth = 0.5
        separator.moveToPoint(CGPoint(x:self.frame.origin.x, y:40))
        separator.addLineToPoint(CGPoint(x:self.frame.origin.x + self.frame.size.width, y:40))
        separator.stroke()

        
    }
}
