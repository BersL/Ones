//
//  PopupSettingView.swift
//  Ones
//
//  Created by Bers on 15/3/9.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class PopupSettingView: UIView {
    
    var enableNotificationLabel : UILabel!
    var enableNotificationSwitch : UISwitch!
    var enableSoundLabel : UILabel!
    var enableSoundSwitch : UISwitch!
    var popupView : PopupView!
    var popupViewFrame : CGRect!
    var showPoint : CGPoint!
    var arrowHeight : CGFloat = 10
    let bkgColor = UIColor(white: 0.95, alpha: 1.0)
    
    override init(frame:CGRect){
        super.init(frame:UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    func show(){
        UIApplication.sharedApplication().windows[0].addSubview(self)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.popupView.transform = CGAffineTransformMakeScale(1.05, 1.05)
            self.popupView.alpha = 1.0
        }) { (finished:Bool) -> Void in
            UIView.animateWithDuration(0.08, animations: { () -> Void in
                self.popupView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    func dismiss(){
        UIView.animateWithDuration(0.08, animations: { () -> Void in
            self.popupView.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }) { [unowned self] (finished:Bool) -> Void in
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.popupView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.popupView.alpha = 0.0
                }, completion: { (finished: Bool) -> Void in
                self.removeFromSuperview()
            })
            
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        dismiss()
    }
    
    convenience init(showPoint:CGPoint, frame:CGRect, heightForArrow:CGFloat = 10){
        self.init(frame:frame)
        self.arrowHeight = heightForArrow
        self.showPoint = showPoint
        var popupViewFrame = frame
        popupView = PopupView(frame: popupViewFrame)
        popupView.showPoint = showPoint
        popupView.alpha = 0.0
        self.addSubview(popupView)

        self.popupViewFrame = popupView.frame
        let anchor = CGPoint(x:0.2, y:0)
        popupView.layer.anchorPoint = anchor;
        var center = popupView.center
        center.y -= 33
        center.x -= 40
        popupView.center = center
        popupView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        
        var labelRect = CGRectMake(3, CGFloat(arrowHeight + 9), 50, 15)
        enableNotificationLabel = UILabel(frame: labelRect)
        enableNotificationLabel.font = UIFont.systemFontOfSize(12)
        enableNotificationLabel.text = "每日未打卡提醒"
        enableNotificationLabel.textColor = UIColor.whiteColor()
        enableNotificationLabel.backgroundColor = UIColor.clearColor()
        enableNotificationLabel.sizeToFit()
        self.popupView.addSubview(enableNotificationLabel)
        
        var switchRect = CGRectMake(CGFloat(2 + enableNotificationLabel.frame.size.width), CGFloat(arrowHeight), 45, 8)
        enableNotificationSwitch = UISwitch(frame: switchRect)
        let notificationType = UIApplication.sharedApplication().currentUserNotificationSettings()
        if notificationType.types == UIUserNotificationType.None{
            enableNotificationSwitch.on = false
        }else{
            enableNotificationSwitch.on = true
        }
        enableNotificationSwitch.addTarget(self, action: Selector("enableNotificationSwitchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        enableNotificationSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6)
        self.popupView.addSubview(enableNotificationSwitch)
        
        labelRect.origin.y += CGFloat(30)
        enableSoundLabel = UILabel(frame: labelRect)
        enableSoundLabel.font = UIFont.systemFontOfSize(12)
        enableSoundLabel.text = "播放音效"
        enableSoundLabel.textColor = UIColor.whiteColor()
        enableSoundLabel.backgroundColor = UIColor.clearColor()
        enableSoundLabel.sizeToFit()
        self.popupView.addSubview(enableSoundLabel)
        
        switchRect.origin.y += CGFloat(30)
        enableSoundSwitch = UISwitch(frame: switchRect)
        enableSoundSwitch.on = NSUserDefaults.standardUserDefaults().valueForKey("soundEnabledState") as! Bool
        enableSoundSwitch.addTarget(self, action: Selector("enableNotificationSwitchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        enableSoundSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6)
        self.popupView.addSubview(enableSoundSwitch)

    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    func enableNotificationSwitchValueChanged(sender:UISwitch){
        if sender == enableNotificationSwitch {
            if sender.on {
                if (UIApplication.sharedApplication().currentUserNotificationSettings().types == UIUserNotificationType.None) {
                    sender.on = false
                    PromptHUD.sharedPromptHUD.showWithStyle(PromptHUDStyle.Warning)
                }else{
                     NSUserDefaults.standardUserDefaults().setValue(true, forKey: "notificationEnabledState")
                }
            }else{
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "notificationEnabledState")
                UIApplication.sharedApplication().cancelAllLocalNotifications()
            }
        }else{
            if sender.on {
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "soundEnabledState")
                PromptHUD.sharedPromptHUD.showWithStyle(PromptHUDStyle.SoundEnabled)
            }else{
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "soundEnabledState")
                PromptHUD.sharedPromptHUD.showWithStyle(PromptHUDStyle.SoundDisabled)
            }
        }
        
    }
    
    
}
