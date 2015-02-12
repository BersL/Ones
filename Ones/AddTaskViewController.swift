//
//  AddTaskViewController.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit
import Foundation

class AddTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var everydayChoice: UIImageView!
    @IBOutlet weak var dayChoice: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var daysTxtField: UITextField!
    
    @IBOutlet weak var submitBtn: bordedButton!
    @IBOutlet var subViews: [UIView]!

    var bkgImg : UIImage!
    var selectedImg , unselectedImg : UIImage!
    var segueImgVToRemove : UIImageView?
    
    var everydaySelected : Bool = true{
        didSet{
            if everydaySelected {
                self.everydayChoice.image = self.selectedImg
                self.dayChoice.image = self.unselectedImg
            }else{
                self.everydayChoice.image = self.unselectedImg
                self.dayChoice.image = self.selectedImg
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.image = bkgImg
        // Do any additional setup after loading the view.
        self.selectedImg = UIImage(named: "selected.png")
        self.unselectedImg = UIImage(named: "unselected.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        self.everydaySelected = true
    }
    @IBAction func handleTap2(sender: UITapGestureRecognizer) {
        self.everydaySelected = false
        self.daysTxtField.becomeFirstResponder()
    }

    @IBAction func everydayBtnPressed(sender: AnyObject) {
        self.everydaySelected = true
        self.nameTxtField.resignFirstResponder()
        self.daysTxtField.resignFirstResponder()
    }
    @IBAction func daySelected(sender: UITextField) {
        self.everydaySelected = false
    }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.nameTxtField.resignFirstResponder()
        self.daysTxtField.resignFirstResponder()
    }
    
    @IBAction func daysEndEditing(sender: AnyObject) {
        if let day = self.daysTxtField.text.toInt(){
            if day == 0{
                self.everydaySelected = true
                self.daysTxtField.text == ""
            }
        }else{
            self.everydaySelected = true
            self.daysTxtField.text == ""
        }
        
    }
    
    @IBAction func nameEndEditing(sender: UITextField) {
        self.submitBtn.enabled = !sender.text.isEmpty
        if count(sender.text) > 16 {
            sender.text = sender.text.substringToIndex(advance(sender.text.startIndex, 16))
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTaskUnwindDone" {
            let dest = segue.destinationViewController as! MasterViewController
            let days = self.daysTxtField.text.toInt()
            if let day = days {
                dest.taskToAdd = (self.nameTxtField.text , day)
            }else{
                dest.taskToAdd = (self.nameTxtField.text , -1)
            }
        }else if segue.identifier == "addTaskUnwindCancel" {
            
        }
        
    }


}
