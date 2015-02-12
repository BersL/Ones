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
    var topImg : UIImage?
    var bottomImg : UIImage?
    var topImgOrigionFrame : CGRect?
    var bottomImgOrigionFrame : CGRect?
    var noTaskImgV : UIImageView!
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
                aNewTask.clockRecord = [String:Bool]()
                self.tasksArray.insert(aNewTask, atIndex: 0)
                manageObjectContextSave()
                noTaskImgV.hidden = true
                self.tableView.reloadData()

            }
        }
    }
    var todayStr ,yesterdayStr: String!
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        noTaskImgV = UIImageView(frame: CGRectMake(self.view.bounds.width - 145, 0, 150, 100))
        noTaskImgV.image = UIImage(named: "noTask.png")
        self.tableView.addSubview(noTaskImgV)
        noTaskImgV.hidden = true
        
        // Do any additional setup after loading the view.
        var request = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.managedObjectContext!)
        request.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var err : NSError?
        var fetchResults = self.managedObjectContext?.executeFetchRequest(request, error: &err)
        if let results = fetchResults as? [Task]{
            self.tasksArray = results
        }else{
            fatalError("Fetch Data Error!")
        }
        if tasksArray.count == 0{
            noTaskImgV.hidden = false
        }
        self.navigationController!.navigationBar.barTintColor = navigationBarBKGColor
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 80, 30))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.text = "Ones"
        self.navigationItem.titleView = titleLabel
        
        var date = NSDate()
        var compo = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: date)
        todayStr = "\(compo.year)\(compo.month)\(compo.day)"
        
        date = NSDate(timeIntervalSinceNow: -24*3600)
        compo = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: date)
        yesterdayStr = "\(compo.year)\(compo.month)\(compo.day)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Animation Layer Process

//    func setupTextLayerWithText (text:String){
//        pathLayer?.removeFromSuperlayer()
//        pathLayer = nil
//        
//        let letters : CGMutablePathRef = CGPathCreateMutable()
//        let font : CTFontRef = CTFontCreateWithName("Heiti SC-Bold" as CFStringRef, 72.0, nil)
//        let attributes :[NSObject:AnyObject] = [kCTFontAttributeName:font]
//        let attributedStr = NSAttributedString(string: text, attributes: attributes)
//        var line = CTLineCreateWithAttributedString(attributedStr as CFAttributedStringRef);
//        var runArray = CTLineGetGlyphRuns(line);
//        for var runIndex :CFIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++ {
//            var run : CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), CTRun.self)
//            let dict : NSDictionary = CTRunGetAttributes(run)
//            var runFont = dict.valueForKey(kCTFontAttributeName as! String) as! CTFontRef
//            for var runGlyphIndex :CFIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++ {
//                var thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
//                var glyph = CGGlyph()
//                var position = CGPoint()
//                CTRunGetGlyphs(run, thisGlyphRange, &glyph);
//                CTRunGetPositions(run, thisGlyphRange, &position);
//                var letter = CTFontCreatePathForGlyph(runFont, glyph, nil);
//                var t = CGAffineTransformMakeTranslation(position.x, position.y);
//                CGPathAddPath(letters, &t, letter);
//            }
//        }
//        
//        let path = UIBezierPath()
//        path.moveToPoint(CGPointZero)
//        path.appendPath(UIBezierPath(CGPath: letters))
//        pathLayer = CAShapeLayer()
//        pathLayer!.frame = self.tableView.bounds
//        pathLayer!.bounds = CGPathGetBoundingBox(path.CGPath);
//        pathLayer!.backgroundColor = UIColor.yellowColor().CGColor
//        pathLayer!.geometryFlipped = true
//        pathLayer!.strokeColor = UIColor.redColor().CGColor
//        pathLayer!.fillColor = nil;
//        pathLayer!.lineWidth = 10.0;
//        pathLayer!.lineJoin = kCALineJoinBevel
////        self.tableView.hidden = true
//        animationLayer?.addSublayer(pathLayer)
//    }
//    
//    func startAnimation () {
//        pathLayer!.removeAllAnimations()
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.duration = 2.0
//        animation.delegate = self
//        animation.fromValue = NSNumber(double: 0.0)
//        animation.toValue = NSNumber(double: 1.0)
//        pathLayer!.addAnimation(animation, forKey: "strokeEnd")
//    }
    
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
        cell?.indexPath = indexPath
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
        let toExchange = tasksArray[row1]
        tasksArray.removeAtIndex(row1)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row1, inSection: 0)], withRowAnimation:UITableViewRowAnimation.Bottom)
        tasksArray.insert(toExchange, atIndex: row2)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    
    func removeTaskAt(#row:Int){
        let taskToDelete = tasksArray[row]
        managedObjectContext?.deleteObject(taskToDelete)
        tasksArray.removeAtIndex(row)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        manageObjectContextSave()
        if tasksArray.count == 0 {
            noTaskImgV.hidden = false
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
    func cellFinishStateChanged(finished: Bool , indexPath: NSIndexPath) {
        var task = tasksArray[indexPath.row]
        task.clockRecord[todayStr] = finished
        
        if finished{
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
        }
        manageObjectContextSave()
        
        if finished {
            if indexPath.row != tasksArray.count - 1{
                if tasksArray[indexPath.row + 1].clockRecord[todayStr] == nil || !(tasksArray[indexPath.row + 1].clockRecord[todayStr]!){
                    var tempIndexPathArr = [NSIndexPath]()
                    var tempStateArr = [Bool]()
                    for index in indexPath.row...self.tasksArray.count - 1{
                        var row : TaskTableViewCell!
                        if index >= 9 {
                            row = self.tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        }else {
                            row = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        }
                        tempIndexPathArr.append(row.indexPath)
                        tempStateArr.append(row.finishedState)
                    }
                    
                    exchangeTableViewCellsWithRow1(indexPath.row, row2: tasksArray.count - 1)
                    for index in indexPath.row...self.tasksArray.count - 1{
                        var row : TaskTableViewCell!
                        if index >= 9{
                            row = self.tableView(self.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        }else{
                            row = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        }
                        row.indexPath = tempIndexPathArr[index - indexPath.row]
                        if index == self.tasksArray.count - 1{
                            row.finishedState = tempStateArr[indexPath.row - indexPath.row]
                        }else{
                            row.finishedState = tempStateArr[index + 1 - indexPath.row]
                        }
                    }
                }
            }
        } else {
            if indexPath.row != 0{
                if (tasksArray[indexPath.row - 1].clockRecord[todayStr] != nil && tasksArray[indexPath.row - 1].clockRecord[todayStr]!) {
                    var row1 = tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell
                    var row2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TaskTableViewCell
                    //                target.indexPath = cell.indexPath
                    //                cell.indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    //                swap(&cell.finishedState, &target.finishedState)
                    let tempCell1IndexPath = row1.indexPath
                    let tempCell1State = row1.finishedState
                    
                    let tempCell2IndexPath = row2.indexPath
                    let tempCell2State = row2.finishedState
                    var tempIndexPathArr = [NSIndexPath]()
                    var tempStateArr = [Bool]()
                    for index in 0...indexPath.row{
                        let row = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        tempIndexPathArr.append(row.indexPath)
                        tempStateArr.append(row.finishedState)
                    }
                    
                    exchangeTableViewCellsWithRow1(indexPath.row, row2: 0)
                    for index in 0...indexPath.row{
                        let row = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaskTableViewCell
                        row.indexPath = tempIndexPathArr[index]
                        if index == 0{
                            row.finishedState = tempStateArr[indexPath.row]
                        }else{
                            row.finishedState = tempStateArr[index - 1]
                        }
                    }
                    
                }
            }
        }
        
    }
    

    //End
    
    func playSound(){
        var  soundID : SystemSoundID = 0
        var url : NSURL = NSBundle.mainBundle().URLForResource("clocked", withExtension: "caf")!
        AudioServicesCreateSystemSoundID(url as CFURLRef, &soundID)
        AudioServicesPlaySystemSound(soundID)
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
