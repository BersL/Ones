//
//  CustomSegue.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit
import AudioToolbox

class CustomSegue: UIStoryboardSegue {
    
    var dynamicAnimator : UIDynamicAnimator?
    
    override func perform() {
        let dest = self.destinationViewController as! UIViewController
        let src = self.sourceViewController as! MasterViewController
        let row = src.tableView.indexPathForSelectedRow()!.row + 1
        
        let rowHeight = CGFloat(60 * row)
        let cutRect = CGRectMake(0, rowHeight + 64 , src.view.bounds.size.width, src.view.bounds.size.height - rowHeight - 64)
        let remainRect = CGRectMake(0, 64 , src.view.bounds.size.width, rowHeight)
        
        let img = self.takeSnapshot()
        let cutCGImg = CGImageCreateWithImageInRect(img.CGImage, cutRect.doubledRect())
        let cutImg = UIImage(CGImage: cutCGImg)
        let cutImgV = UIImageView(frame: cutRect)
        
        let remainCGImg = CGImageCreateWithImageInRect(img.CGImage, remainRect.doubledRect())
        let remainImg = UIImage(CGImage: remainCGImg)
        let remainImgV = UIImageView(frame: remainRect)
        
        src.topImg = remainImg
        src.bottomImg = cutImg
        
        cutImgV.image = cutImg
        remainImgV.image = remainImg
        src.view.alpha = 0.0
        src.view.superview!.addSubview(dest.view)
        src.view.superview!.addSubview(cutImgV)
        src.view.superview!.addSubview(remainImgV)
        dest.view.alpha = 0.0
        dest.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        self.playSound()
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            cutImgV.center.y += cutRect.size.height
            remainImgV.center.y -= remainRect.size.height
            src.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
            src.navigationItem.titleView?.alpha = 0
        }) { (finished:Bool) -> Void in
            remainImgV.removeFromSuperview()
            cutImgV.removeFromSuperview()
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                dest.view.alpha = 1.0
                dest.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
                return
            }, completion: { (finished:Bool) -> Void in
                dest.view.removeFromSuperview()
                src.topImgOrigionFrame = remainImgV.frame
                src.bottomImgOrigionFrame = cutImgV.frame
                src.navigationController?.pushViewController(dest, animated: false)
            })
        }
    }
    
    func takeSnapshot() -> UIImage {
        let src = self.sourceViewController as! UIViewController
        
        UIGraphicsBeginImageContextWithOptions(src.view.bounds.size, false, UIScreen.mainScreen().scale);
        
        src.view.drawViewHierarchyInRect(src.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    func playSound(){
        var  soundID : SystemSoundID = 0
        var url : NSURL = NSBundle.mainBundle().URLForResource("taskOpen", withExtension: "caf")!
        AudioServicesCreateSystemSoundID(url as CFURLRef, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
}

extension CGRect{
    func doubledRect() -> CGRect{
        return CGRectMake(self.origin.x*2,self.origin.y*2,self.size.width*2,self.size.height*2)
    }
}