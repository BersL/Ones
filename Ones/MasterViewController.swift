//
//  MasterViewController.swift
//  Ones
//
//  Created by Bers on 15/2/5.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import QuartzCore

public let navigationBarBKGColor = UIColor(red: 117/255, green: 138/255, blue: 153/255, alpha: 1.0)
public let globalTextColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)


class MasterViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,taskTableViewCellDelegate{

    var managedObjectContext : NSManagedObjectContext?
    var tasksArray : [Task]!
    var topImg : UIView?
    var bottomImg : UIView?
    var noTaskImgV : UIImageView!
    var todayStr ,yesterdayStr: String!
    var pathLayer : CAShapeLayer?
    var settingView : PopupSettingView!
    var taskToAdd : (String, Int)?{
        didSet{
            if let (title , days) = taskToAdd {
                var aNewTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: self.managedObjectContext!) as! Task
                aNewTask.title = title
                aNewTask.plannedDays = days
                aNewTask.currentPersist = 0
                aNewTask.longestPersist = 0
                aNewTask.totalPersist = 0
                aNewTask.startDate = NSDate()
                aNewTask.endDateStr = NSDate(timeIntervalSinceNow: NSTimeInterval(days * 24 * 3600)).dateString()
                aNewTask.clockRecord = [String:Bool]()
                aNewTask.index = NSNumber(int: 0)
                for task in tasksArray {
                    task.index = NSNumber(int:task.index.intValue + 1)
                }
                self.tasksArray.insert(aNewTask, atIndex: 0)
                manageObjectContextSave()
                taskArrayIsEmpty(false)
                self.tableView.reloadData()

            }
        }
    }
    var clockedTaskNumber : Int = 0 {
        didSet{
            if clockedTaskNumber == tasksArray.count {
                UIApplication.sharedApplication().cancelAllLocalNotifications()
            }else{
                if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 && NSUserDefaults.standardUserDefaults().objectForKey("notificationEnabledState") as! Bool{
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                }
            }
        }
    }
    lazy var notification : UILocalNotification = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let firstDate = formatter.dateFromString("17:00:00")
        let tempNotification = UILocalNotification()
        tempNotification.fireDate = firstDate
        tempNotification.timeZone = NSTimeZone.defaultTimeZone()
        tempNotification.applicationIconBadgeNumber = 1
        tempNotification.soundName = UILocalNotificationDefaultSoundName
        tempNotification.repeatInterval = NSCalendarUnit.DayCalendarUnit
        tempNotification.alertBody = "你今天还有没打卡的事项哦^_^"
        tempNotification.fireDate = firstDate
        return tempNotification
    }()
    
    
    @IBOutlet weak var settingBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        noTaskImgV = UIImageView(frame: CGRectMake(self.view.bounds.width - 145, 0, 150, 100))
        noTaskImgV.image = UIImage(named: "noTask.png")
        self.tableView.addSubview(noTaskImgV)
        noTaskImgV.alpha = 0.0

        // Do any additional setup after loading the view.
        fetchData()
        
        self.navigationController!.navigationBar.barTintColor = navigationBarBKGColor
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 30))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.text = "Ones"
        self.navigationItem.titleView = titleLabel
        
        let showPoint = CGPoint(x: 27, y: 0)
        let settingViewFrame = CGRectMake(2, 55, 130, 70)
        settingView = PopupSettingView(showPoint: showPoint, frame: settingViewFrame, heightForArrow: 10)
    }
    
    
    func taskArrayIsEmpty(empty:Bool){
        if empty {
            setupTextLayerWithText("Ones")
            startAnimation()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }else{
            pathLayer?.removeAllAnimations()
            pathLayer?.removeFromSuperlayer()
            pathLayer = nil
            noTaskImgV.alpha = 0.0
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let firstDate = formatter.dateFromString("21:00:00")
            
            if NSUserDefaults.standardUserDefaults().objectForKey("notificationEnabledState") as! Bool{
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
        tableView.scrollEnabled = !empty;
    }
    
    func fetchData(){
        var request = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.managedObjectContext!)
        request.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var err : NSError?
        var fetchResults = self.managedObjectContext?.executeFetchRequest(request, error: &err)
        if let results = fetchResults as? [Task]{
            self.tasksArray = results
        }else{
            fatalError("Fetch Data Error!")
        }
        todayStr = NSDate().dateString()
        yesterdayStr = NSDate(timeIntervalSinceNow: -24*3600).dateString()
        
        for var i = 0 ; i < tasksArray.count ;++i{
            let item = tasksArray[i]
            if item.endDateStr.toInt()! <= todayStr.toInt()! && item.plannedDays != -1{
                for var index = i + 1; index < self.tasksArray.count ; ++index{
                    tasksArray[index].index = NSNumber(int: tasksArray[index].index.intValue - 1)
                }
                managedObjectContext?.deleteObject(item)
                tasksArray.removeAtIndex(i)
                manageObjectContextSave()
            }
        }
        
        if tasksArray.count == 0{
            taskArrayIsEmpty(true);
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingBtnPressed(sender: UIBarButtonItem) {
        settingView.show()
    }
    //Animation Layer Process
    func setupTextLayerWithText (text:String){
        pathLayer?.removeFromSuperlayer()
        pathLayer = nil
        
        let font : CTFontRef = CTFontCreateWithName("Menlo-Regular" as CFStringRef, 72.0, nil)
        let attributes :[NSObject:AnyObject] = [kCTFontAttributeName:font]
        let attributedStr = NSAttributedString(string: text, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedStr)
        let runArray = CTLineGetGlyphRuns(line) as! [CTRunRef]
        
        let letters = CGPathCreateMutable()
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run: CTRunRef = runArray[runIndex]
            
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph: CGGlyph = CGGlyph()
                var position: CGPoint = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)
                
                let letter = CTFontCreatePathForGlyph(font, glyph, nil)
                var t = CGAffineTransformMakeTranslation(position.x, position.y);
                
                CGPathAddPath(letters, &t, letter)
            }
        }
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.appendPath(UIBezierPath(CGPath: letters))
        pathLayer = CAShapeLayer()
        pathLayer!.frame = self.tableView.bounds
        pathLayer!.bounds = CGPathGetBoundingBox(path.CGPath);
        pathLayer!.backgroundColor = UIColor.clearColor().CGColor
        pathLayer!.geometryFlipped = true
        pathLayer!.strokeColor = UIColor.blackColor().CGColor
        pathLayer!.fillColor = UIColor.clearColor().CGColor;
        pathLayer!.lineWidth = 2.0;
        pathLayer!.lineJoin = kCALineJoinBevel
        pathLayer!.path = path.CGPath
        var frame = pathLayer!.frame
        frame.origin.x = (UIScreen.mainScreen().bounds.size.width - frame.size.width)/2
        frame.origin.y = (UIScreen.mainScreen().bounds.size.height - frame.size.height)/2 - 64
        pathLayer!.frame = frame
        self.tableView.layer.addSublayer(pathLayer)
    }

    func startAnimation () {
        pathLayer!.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 3.5
        animation.delegate = self
        animation.fromValue = 0.0
        animation.toValue = 1.0
        pathLayer!.addAnimation(animation, forKey: "strokeEnd")
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        pathLayer?.opacity = 0.5
        UIView.animateWithDuration(0.5, animations: { [unowned self] () -> Void in
            self.noTaskImgV.alpha = 1.0
            return
        })
        
    }
    //End
    

    // Table View DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("taskCell") as? TaskTableViewCell
        cell?.textLabel?.text = tasksArray[indexPath.row].title
        cell?.delegate = self
        if let clocked = tasksArray[indexPath.row].clockRecord[todayStr]{
            cell!.finishedState = clocked
        }else{
            cell!.finishedState = false
        }
        cell?.startPoint = nil
        cell?.endPoint = nil
        cell?.setNeedsDisplay()
        cell?.textLabel?.alpha = (cell!.finishedState) ? 0.3 : 1.0
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    //End
    
    func exchangeTableViewCellsWithRow1(row1: Int, row2: Int){
        if row1<row2{
            for i in row1 + 1...row2{
                tasksArray[i].index = NSNumber(int: tasksArray[i].index.intValue - 1)
            }
            tasksArray[row1].index = NSNumber(integer: row2)
        }else{
            for i in row2...row1 - 1{
                tasksArray[i].index = NSNumber(int: tasksArray[i].index.intValue + 1)
            }
            tasksArray[row1].index = NSNumber(integer: row2)
        }
        let toExchange = tasksArray[row1]
        tasksArray.removeAtIndex(row1)
        tasksArray.insert(toExchange, atIndex: row2)
        tableView.moveRowAtIndexPath(NSIndexPath(forRow: row1, inSection: 0), toIndexPath: NSIndexPath(forRow: row2, inSection: 0))
        manageObjectContextSave()

        
    }
    
    
    func removeTaskAt(#row:Int){
        let taskToDelete = tasksArray[row]
        for var i = Int(taskToDelete.index) + 1; i<self.tasksArray.count; ++i{
            tasksArray[i].index = NSNumber(int: tasksArray[i].index.intValue - 1)
        }
        managedObjectContext?.deleteObject(taskToDelete)
        tasksArray.removeAtIndex(row)
        
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        manageObjectContextSave()
        if tasksArray.count == 0 {
            taskArrayIsEmpty(true)
        }
    }
    
    func manageObjectContextSave (){
        var err : NSError?
        managedObjectContext?.save(&err)
        if err != nil{
            fatalError("Unresolved error \(err) \(err?.description) ")
        }
    }
    
    //Delegates
    func cellFinishStateChanged(finished: Bool , cell: UITableViewCell) {
        let indexPath = tableView.indexPathForCell(cell) as NSIndexPath!
        var task = tasksArray[indexPath.row]
        task.clockRecord[todayStr] = finished
        
        if finished{
            PromptHUD.sharedPromptHUD.showWithStyle(PromptHUDStyle.CheckMark)
            playSound()
            task.totalPersist = NSNumber(int: Int(task.totalPersist) + 1)
            if task.longestPersist.intValue == 0 {
                task.longestPersist = NSNumber(int: 1)
            }
            if let yestBool = task.clockRecord[yesterdayStr] {
                if yestBool{
                    task.currentPersist = NSNumber(int: Int(task.currentPersist) + 1)
                    if task.currentPersist.intValue > task.longestPersist.intValue {
                        task.longestPersist = task.currentPersist.copy() as! NSNumber
                    }
                }else{
                    task.currentPersist = NSNumber(int: 1)
                }
            }else{
                task.currentPersist = NSNumber(int: 1)
            }
            clockedTaskNumber += 1
        }else{
            task.totalPersist = NSNumber(int: task.totalPersist.intValue - 1)
            if task.longestPersist.intValue == 1 {
                task.longestPersist = NSNumber(int: 0)
            }
            task.currentPersist = NSNumber(int: task.currentPersist.intValue - 1)
            if let yestBool = task.clockRecord[yesterdayStr] {
                if yestBool{
                    task.longestPersist = NSNumber(int: task.longestPersist.intValue - 1)
                }
            }
            clockedTaskNumber -= 1
        }
        
        manageObjectContextSave()
        
        if finished {
            if indexPath.row != tasksArray.count - 1{
                var nextTask = tasksArray[indexPath.row + 1]
                if let nextTaskClockRecord =  nextTask.clockRecord[todayStr] {
                    if nextTaskClockRecord {
                        return
                    }
                }
                exchangeTableViewCellsWithRow1(indexPath.row, row2: tasksArray.count - 1)
            }
        } else {
            if indexPath.row != 0{
                var lastTask = tasksArray[indexPath.row - 1]
                if let lastTaskClockRecord = lastTask.clockRecord[todayStr]{
                    if !lastTaskClockRecord{
                        return
                    }
                }
                exchangeTableViewCellsWithRow1(indexPath.row, row2: 0)
            }
        }
    }

    //End

    func playSound(){
        if NSUserDefaults.standardUserDefaults().objectForKey("soundEnabledState") as! Bool {
            var  soundID : SystemSoundID = 1
            var url : NSURL = NSBundle.mainBundle().URLForResource("clocked", withExtension: "caf")!
            AudioServicesCreateSystemSoundID(url as CFURLRef, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "customSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow()
            let detailVC = (segue.destinationViewController as! DetailViewController)
            if !(tasksArray.isEmpty) {
                detailVC.task = tasksArray[(indexPath?.row)!]
            }
        }else if segue.identifier == "addTask"{
            let dest = segue.destinationViewController as! AddTaskViewController
            dest.bkgImg = self.takeSnapshot(navigationBar: true)
        }
    }
    
    @IBAction func unwind(segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromAddTask (segue: UIStoryboardSegue){
        
    }
    
    
    func takeSnapshot(navigationBar withNavigationBar:Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale);
        if withNavigationBar {
            UIApplication.sharedApplication().delegate?.window??.rootViewController?.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        }else{
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    


}

extension NSDate{
    func dateString() -> String{
        var compo = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: self)
        let month :String = compo.month < 10 ? "0\(compo.month)" : "\(compo.month)"
        let day :String = compo.day < 10 ? "0\(compo.day)" : "\(compo.day)"
        let dateStr = "\(compo.year)\(month)\(day)"
        return dateStr
    }
}
