//
//  CustomUnwindSegue.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class CustomUnwindSegue: UIStoryboardSegue {
    var topImg : UIView!
    var bottomImg : UIView?
    
    override func perform() {
        let src = self.sourceViewController as! UIViewController
        let dest = self.destinationViewController as! MasterViewController
        
        let topImgV = topImg
        let bottomImgV = bottomImg
        
        src.view.superview!.addSubview(topImgV)
        if let btmImg = bottomImgV{
            src.view.superview!.addSubview(btmImg)
        }
        
        UIView.animateWithDuration(0.6, animations: {[unowned self] () -> Void in
            src.view.alpha = 0.0
            topImgV.center.y += topImgV.frame.size.height
            if let btmImg = bottomImgV{
                btmImg.center.y -= btmImg.frame.size.height
            }
            src.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
            src.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
            src.navigationItem.rightBarButtonItem?.enabled = false
            src.navigationItem.leftBarButtonItem?.enabled = false
            }) { (finished:Bool) -> Void in
                dest.view.alpha = 1.0
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    dest.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
                    dest.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
                    dest.navigationItem.titleView?.alpha = 1.0
                    return
                    }, completion: {(finished:Bool) -> Void in
                        bottomImgV?.removeFromSuperview()
                        dest.view.removeFromSuperview()
                        src.navigationController?.popViewControllerAnimated(false)
                        if self.identifier == "unwindWithDelete" {
                            dest.removeTaskAt(row:dest.tableView.indexPathForSelectedRow()!.row)
                        }else{
                            dest.tableView.reloadData()
                        }
                        dest.navigationItem.leftBarButtonItem?.enabled = true
                        dest.navigationItem.rightBarButtonItem?.enabled = true
                        
                })
                
        }

    }
    
   
}


