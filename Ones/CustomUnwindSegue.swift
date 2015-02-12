//
//  CustomUnwindSegue.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class CustomUnwindSegue: UIStoryboardSegue {
    var topImg : UIImage!
    var bottomImg : UIImage!
    var topImgOrigionFrame : CGRect!
    var bottomImgOrigionFrame : CGRect!

    override func perform() {
        let src = self.sourceViewController as! UIViewController
        let dest = self.destinationViewController as! MasterViewController
        
        let topImgV = UIImageView(image: topImg)
        let bottomImgV = UIImageView(image: bottomImg)
        topImgV.frame = topImgOrigionFrame
        bottomImgV.frame = bottomImgOrigionFrame
        
        src.view.superview!.addSubview(topImgV)
        src.view.superview!.addSubview(bottomImgV)
        
        UIView.animateWithDuration(0.6, animations: {[unowned self] () -> Void in
            src.view.alpha = 0.0
            topImgV.center.y += topImgV.frame.size.height
            bottomImgV.center.y -= bottomImgV.frame.size.height
            src.navigationItem.leftBarButtonItem?.tintColor = UIColor.clearColor()
            }) { (finished:Bool) -> Void in
                dest.view.alpha = 1.0
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    dest.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
                    dest.navigationItem.titleView?.alpha = 1.0
                    return
                    }, completion: {(finished:Bool) -> Void in
                        bottomImgV.removeFromSuperview()
                        dest.view.removeFromSuperview()
                        src.navigationController?.popViewControllerAnimated(false)
                        if self.identifier == "unwindWithDelete" {
                            dest.removeTaskAt(row:dest.tableView.indexPathForSelectedRow()!.row)
                        }else{
                            dest.tableView.reloadData()
                        }
                        
                })
                
        }

    }
    
   
}


