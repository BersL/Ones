//
//  MyNavController.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class MyNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if identifier == "unwindFromDetailView" || identifier == "unwindWithDelete"{
            var segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController) { () -> Void in}
            let src = self.viewControllers[0] as! MasterViewController
            segue.topImg = src.topImg!
            segue.bottomImg = src.bottomImg!
            segue.topImgOrigionFrame = src.topImgOrigionFrame!
            segue.bottomImgOrigionFrame = src.bottomImgOrigionFrame!
            return segue
        }else {
            var segue = AddTaskUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController, performHandler: { () -> Void in })
            return segue
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

}
