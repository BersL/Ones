//
//  HUDViewController.swift
//  Ones
//
//  Created by Bers on 15/3/15.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class HUDViewController: UIViewController {
    
    var label : UILabel!
    var promptImgV : UIImageView!
    lazy var checkmark : UIImage = {
        return  UIImage(named: "checkmark.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }()
    
    lazy var warning : UIImage = {
        return UIImage(named: "warning.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }()
    
    lazy var soundEnabled : UIImage = {
        return UIImage(named: "soundEnabled.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }()
    
    lazy var soundDisabled : UIImage = {
        return UIImage(named: "soundDisabled.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        self.view.layer.cornerRadius = 5.0

        label = UILabel(frame: CGRectMake(0, 85, 110, 16))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        promptImgV = UIImageView(frame: CGRectMake(20, 10, 70, 70))
        promptImgV.tintColor = UIColor.whiteColor()
        self.view.addSubview(promptImgV)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.frame = CGRectMake(0, 0, 110, 110)
        super.viewWillAppear(animated)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
                // Do any additional setup after loading the view.
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showWithStyle(style:PromptHUDStyle){
        switch style{
        case .CheckMark:
            self.promptImgV.image = checkmark
            self.label.text = "打卡成功"
        case .Warning:
            self.promptImgV.image = warning
            self.label.text = "请在系统设置中开启"
        case .SoundEnabled:
            self.promptImgV.image =  soundEnabled
            self.label.text = "音效开启"
        case .SoundDisabled:
            self.promptImgV.image = soundDisabled
            self.label.text = "音效关闭"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
