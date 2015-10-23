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
    
    override func perform() {
        let dest = self.destinationViewController as! UIViewController
        let src = self.sourceViewController as! MasterViewController
        let row = src.tableView.indexPathForSelectedRow()!.row + 1
        
        let rowHeight = CGFloat(60 * row) - src.tableView.contentOffset.y - 64
        let cutRect = CGRectMake(0, rowHeight + 64 , src.view.bounds.size.width, src.view.bounds.size.height - rowHeight - 64)
        let remainRect = CGRectMake(0, 64 , src.view.bounds.size.width, rowHeight)
        
        let cutView = src.view.resizableSnapshotViewFromRect(cutRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        cutView.frame = cutRect
        let remainView = src.view.resizableSnapshotViewFromRect(remainRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        remainView.frame = remainRect
        
        src.view.alpha = 0.0
        src.view.superview!.addSubview(dest.view)
        src.view.superview!.addSubview(cutView)
        src.view.superview!.addSubview(remainView)
        dest.view.alpha = 0.0
        dest.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
        
        self.playSound()
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            cutView.center.y += cutRect.size.height
            remainView.center.y -= remainRect.size.height
            src.navigationItem.leftBarButtonItem?.enabled = false
            src.navigationItem.rightBarButtonItem?.enabled = false
            src.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
            src.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
            src.navigationItem.titleView?.alpha = 0
        }) { (finished:Bool) -> Void in
            remainView.removeFromSuperview()
            cutView.removeFromSuperview()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                dest.view.alpha = 1.0
                dest.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
                dest.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
                return
            }, completion: { (finished:Bool) -> Void in
                dest.view.removeFromSuperview()
                src.topImg = remainView
                src.bottomImg = cutView
                src.navigationController?.pushViewController(dest, animated: false)
                dest.navigationItem.rightBarButtonItem?.enabled = true
                dest.navigationItem.leftBarButtonItem?.enabled = true
            })
        }
    }
        
    func playSound(){
        if NSUserDefaults.standardUserDefaults().objectForKey("soundEnabledState") as! Bool {
            var  soundID : SystemSoundID = 0
            var url : NSURL = NSBundle.mainBundle().URLForResource("taskOpen", withExtension: "caf")!
            AudioServicesCreateSystemSoundID(url as CFURLRef, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
}
