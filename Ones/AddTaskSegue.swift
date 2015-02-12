//
//  addTaskSegue.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class AddTaskSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.sourceViewController as! MasterViewController
        let dst = self.destinationViewController as! AddTaskViewController
        
        var imgV = UIImageView(frame: dst.view.bounds)
        imgV.image = dst.bkgImg
        insertBlurView(imgV, style: UIBlurEffectStyle.ExtraLight)
        src.view.superview!.addSubview(imgV)
        imgV.alpha = 0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            imgV.alpha = 1.0
            src.navigationController?.navigationBar.alpha = 0
            for view in dst.subViews{
                view.alpha = 1.0
            }
            return
        }) { (finished:Bool) -> Void in
            src.presentViewController(dst, animated: false, completion: nil)
            dst.segueImgVToRemove = imgV
        }
    }
    
    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        var blurEffect = UIBlurEffect(style: style)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
    }

   
}
