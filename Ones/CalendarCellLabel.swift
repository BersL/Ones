//
//  CalendarCellLabel.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class CalendarCellLabel: UILabel {
    
    var dayNumber : Int = 1{
        didSet{
            self.text = String(dayNumber)
        }
    }
    var havePassed : Bool = false{
        didSet{
            if havePassed {
                self.setNeedsDisplay()
            }
        }
    }
    var isToday : Bool = false{
        didSet{
            if oldValue != isToday {
                self.textColor = isToday ? UIColor.whiteColor() : UIColor.blackColor()
                self.setNeedsDisplay()
            }
        }
    }
    
    
    init(frame:CGRect , dayNumber: Int, isToday : Bool = false, havePassed : Bool = false){
        super.init(frame:frame)
        self.dayNumber = dayNumber
        self.text = String(dayNumber)
        self.havePassed = havePassed
        self.isToday = isToday
        self.textAlignment = NSTextAlignment.Center
        self.font = UIFont.boldSystemFontOfSize(15)
        self.textColor = isToday ? UIColor.whiteColor() : UIColor.blackColor()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if isToday {
            let ctx = UIGraphicsGetCurrentContext()
            let diameter = CGFloat(25)
            let origionX = (self.bounds.size.width - diameter) / 2
            let origionY = (self.bounds.size.height - diameter) / 2
            CGContextAddEllipseInRect(ctx, CGRectMake(origionX, origionY, diameter, diameter))
            CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
            CGContextDrawPath(ctx, kCGPathFill);
        }
        
        let width = self.bounds.size.width
        
        if havePassed {
            let ctx = UIGraphicsGetCurrentContext()
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, 12.0, 9.0);
            CGContextAddLineToPoint(ctx, width-11.0, width-10.0);
            CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 0.85);
            CGContextSetLineWidth(ctx, 3);
            CGContextStrokePath(ctx);
        }
        super.drawRect(rect)
    }

}
