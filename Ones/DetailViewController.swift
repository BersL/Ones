//
//  DetailViewController.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var task : Task?
    let chineseMonth = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
    var currentMonthAndYear : (month:Int,year:Int)!{
        didSet{
            if currentMonthAndYear.month <= 0{
                currentMonthAndYear.month = 12
                currentMonthAndYear.year -= 1
            }else if currentMonthAndYear.month > 12{
                currentMonthAndYear.month = 1
                currentMonthAndYear.year += 1
            }
            if (currentMonthAndYear == startMonthAndYear) {
                leftFlipBtn.enabled = false
            }else{
                leftFlipBtn.enabled = true
            }
        }
    }
    
    
    var startMonthAndYear : (Month:Int,Year:Int)!
    @IBOutlet weak var calendarView: CalendarMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftFlipBtn: UIButton!
    @IBOutlet weak var rightFlipBtn: UIButton!
    @IBOutlet weak var plannedDaysLbl: UILabel!
    @IBOutlet weak var longestPersistLbl: UILabel!
    @IBOutlet weak var recentPersistLbl: UILabel!
    @IBOutlet weak var totalPersistLbl: UILabel!
    
    var editDoneAlertAction : UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let startDate = self.task?.startDate
        self.calendarView.clockRecordDict = self.task?.clockRecord

        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: startDate!)
        self.startMonthAndYear = (components.month , components.year)

        setCurrentMonthAndYear()
        self.calendarView.todayMonthAndYear = (currentMonthAndYear.month , currentMonthAndYear.year)
        self.calendarView.calendarMonthAndYear = currentMonthAndYear
        self.plannedDaysLbl.text = "计划坚持天数: \(task!.plannedDays)天"
        if task!.plannedDays == -1 {
            self.plannedDaysLbl.text = "计划坚持: 每天"
        }
        self.longestPersistLbl.text = "最长坚持天数: \(task!.longestPersist)天"
        self.recentPersistLbl.text = "最近坚持天数: \(task!.currentPersist)天"
        self.totalPersistLbl.text = "总坚持天数: \(task!.totalPersist)天"
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 30))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(16)
        titleLabel.text = task?.title
        self.navigationItem.titleView = titleLabel
        
        let editBtn = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: "editPressed")
        editBtn.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = editBtn
    }
    
    func editPressed () {
        var alert = UIAlertController(title: "标题重命名", message: "标题名应少于16字", preferredStyle: UIAlertControllerStyle.Alert)
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction!) -> Void in
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields?.first)
            return
        }
        var doneAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { [unowned self] (action : UIAlertAction!) -> Void in
            let textFiteld = alert.textFields?.first as! UITextField
            self.task?.title = textFiteld.text
            let titleView = self.navigationItem.titleView! as! UILabel
            titleView.text = textFiteld.text
            var err : NSError?
            self.task?.managedObjectContext?.save(&err)
            if err != nil {
                fatalError("Unresolved error \(err) \(err?.description) ")
            }
        
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields?.first)
        }
        editDoneAlertAction = doneAction
        doneAction.enabled = false
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleTextFieldDidChangeNotification:"), name: UITextFieldTextDidChangeNotification, object: textField);
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleTextFieldDidChangeNotification(notification: NSNotification){
        let textField = notification.object as! UITextField
        let length = count(textField.text)
        editDoneAlertAction.enabled = (length>0&&length<=15)
        
    }
    
    @IBAction func deletePressed(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {[unowned self] (action:UIAlertAction!) -> Void in
            return
        })
        let destructiveAction = UIAlertAction(title: "确定删除", style: UIAlertActionStyle.Destructive, handler: { [unowned self](action:UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("unwindWithDelete", sender: self)
            return
        })
        alert.addAction(cancleAction)
        alert.addAction(destructiveAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentMonthAndYear() {
        let now = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: now)
        self.currentMonthAndYear = (components.month , components.year)
        monthLabel.text = chineseMonth[currentMonthAndYear.month - 1]
    }
    
    func flipToLastMonth(){
        if !(currentMonthAndYear == startMonthAndYear) {
            currentMonthAndYear.month = currentMonthAndYear.month - 1
            self.monthLabel.text = chineseMonth[currentMonthAndYear.month - 1]
            calendarView.flipToLastMonthAndYear(currentMonthAndYear)
        }
    }
    
    func flipToNextMonth(){
        currentMonthAndYear.month = currentMonthAndYear.month + 1
        self.monthLabel.text = chineseMonth[currentMonthAndYear.month - 1]
        calendarView.flipToNextMonthAndYear(currentMonthAndYear)
    }
    
    @IBAction func leftBtnPressed(sender: UIButton) {
        self.flipToLastMonth()
    }
    
    @IBAction func leftSwipeHandle(sender: UISwipeGestureRecognizer) {
        self.flipToNextMonth()
    }
    
    @IBAction func rightBtnPressed(sender: UIButton) {
        self.flipToNextMonth()
    }
    
    @IBAction func rightSwipeHandle(sender: AnyObject) {
        self.flipToLastMonth()
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

func == (left : (Int, Int), right : (Int, Int)) -> Bool{
    return (left.0 == right.0) && (left.1 == right.1)
}

