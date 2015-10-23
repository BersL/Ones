//
//  PromptHUD.swift
//  Ones
//
//  Created by Bers on 15/3/13.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

enum PromptHUDStyle {
    case CheckMark
    case Warning
    case SoundEnabled
    case SoundDisabled
}

class PromptHUD: UIWindow {
    
    var promptText : String = ""
    var promptImg : UIImage!
    var rootVC : HUDViewController!
    
    class var sharedPromptHUD: PromptHUD {
        return sharedInstance
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let screenCenter = CGPoint(x: UIScreen.mainScreen().bounds.size.width / 2, y: UIScreen.mainScreen().bounds.size.height / 2)
        self.center = screenCenter
        self.windowLevel = 2001
        self.backgroundColor = UIColor.clearColor()
        rootVC = HUDViewController(nibName: nil, bundle: nil)
        rootViewController = rootVC
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showWithStyle(style: PromptHUDStyle){
        rootVC.showWithStyle(style)
        self.makeKeyWindow()
        self.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.rootVC.view.alpha = 1.0
        }) { (finished:Bool) -> Void in
            
        }
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismiss"), userInfo: nil, repeats: false)
    }
    
    func dismiss(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.rootVC.view.alpha = 0.0
        }) { (finished:Bool) -> Void in
            self.hidden = true
            self.resignKeyWindow()
        }
    }
}

private let sharedInstance = PromptHUD(frame: CGRectMake(0, 0, 110, 110))

