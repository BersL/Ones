//
//  AddTaskUnwindSegue.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class AddTaskUnwindSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.sourceViewController as! AddTaskViewController
        let dst = self.destinationViewController as! MasterViewController
        src.segueImgVToRemove?.removeFromSuperview()
        dst.view.alpha = 0.0
        dst.navigationController?.navigationBar.alpha = 1.0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            for view in src.subViews{
                view.alpha = 0.0
            }
            dst.view.alpha = 1.0
            return
        }) { (finisehd: Bool) -> Void in
            src.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
   
}
