//
//  CalendarMonthView.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class CalendarMonthView: UIView {
    
    var cells = [CalendarCellLabel]()
    var leftCells = [CalendarCellLabel]()
    var rightCells = [CalendarCellLabel]()
    var clockRecordDict : [String:Bool]!
    var todayMonthAndYear : (month:Int, year:Int)!
    
    var calendarMonthAndYear : (month:Int, year:Int)!{
        didSet{
            self.firstWeekDay = self.firstWeekDayInMonthAndYear((calendarMonthAndYear.month, calendarMonthAndYear.year))
            self.setCells()
        }
    }

    var firstWeekDay : Int = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let cellWidth = CGFloat(35)
        let cellHeight = CGFloat(30)

        for index in 1...42{
            let rect = self.frameOfCell(width: cellWidth, height: cellHeight, dayNumber: index, firstDay: 1)
            let cell = CalendarCellLabel(frame: rect, dayNumber: index, isToday: false, havePassed: false)
            self.addSubview(cell)
            cells.append(cell)
            
            var leftRect = rect
            leftRect.origin.x -= 245
            let leftCell = CalendarCellLabel(frame: leftRect, dayNumber: index, isToday: false, havePassed: false)
            self.addSubview(leftCell)
            leftCells.append(leftCell)
            
            var rightRect = rect
            rightRect.origin.x += 245
            let rightCell = CalendarCellLabel(frame: rightRect, dayNumber: index, isToday: false, havePassed: false)
            self.addSubview(rightCell)
            rightCells.append(rightCell)
            
        }
    }
        
    func setCells(){
        for i in 1 ..< firstWeekDay{
            cells[i - 1].text = ""
        }
        let days = self.numberOfDaysInMonthAndYear((calendarMonthAndYear.month, calendarMonthAndYear.year))
        let today = getToday()
        var cnt = firstWeekDay - 1
        for var i = 1; i <= days; ++i {
            cells[cnt++].text = String(i)
        }
        for var i = cnt ; i < 42 ; ++i {
            cells[i].text = ""
        }

        var lastMonth = calendarMonthAndYear.month - 1
        var lastYear = calendarMonthAndYear.year
        if lastMonth == 0 {
            lastMonth = 12
            lastYear -= 1
        }
        let lastMonthFirstWeekDay = firstWeekDayInMonthAndYear((lastMonth, lastYear))
        for i in 1 ..< lastMonthFirstWeekDay{
            leftCells[i - 1].text = ""
        }
        let lastDays = self.numberOfDaysInMonthAndYear((lastMonth, lastYear))
        var cnt1 = lastMonthFirstWeekDay - 1
        for var i = 1; i <= lastDays; ++i {
            leftCells[cnt1++].text = String(i)
        }
        for var i = cnt1 ; i < 42 ; ++i {
            leftCells[i].text = ""
        }
        
        var nextMonth = (calendarMonthAndYear.month + 1) % 13
        var nextYear =  calendarMonthAndYear.year
        if nextMonth == 0 {
            nextMonth = 1
            nextYear += 1
        }
        let nextMonthFirstWeekDay = firstWeekDayInMonthAndYear((nextMonth, nextYear))
        for i in 1 ..< nextMonthFirstWeekDay {
            rightCells[i - 1].text = ""
        }
        let nextDays = self.numberOfDaysInMonthAndYear((nextMonth,nextYear))
        for i in nextMonthFirstWeekDay ... nextDays + nextMonthFirstWeekDay{
            rightCells[i - 1].text = String(i + 1 - nextMonthFirstWeekDay)
        }
        var cnt2 = nextMonthFirstWeekDay - 1
        for var i = 1; i <= nextDays; ++i {
            rightCells[cnt2++].text = String(i)
        }
        for var i = cnt2 ; i < 42 ; ++i {
            rightCells[i].text = ""
        }

        for i in 1...days{
            let dateStr = String(calendarMonthAndYear.year) + String(calendarMonthAndYear.month) + String(i)
            cells[i - 1].havePassed = false
            cells[i - 1].isToday = false
            if let clocked = self.clockRecordDict[dateStr]{
                cells[i - 1].havePassed = clocked
                if todayMonthAndYear == calendarMonthAndYear &&  i == today{
                    cells[i - 1].havePassed = false
                }
            }
        }

        for i in 1...lastDays{
            let dateStr = String(lastYear) + String(lastMonth) + String(i)
            leftCells[i - 1].havePassed = false
            leftCells[i - 1].isToday = false
            if let clocked = self.clockRecordDict[dateStr]{
                leftCells[i - 1].havePassed = clocked
            }
        }

        for i in 1...nextDays{
            let dateStr = String(nextYear) + String(nextMonth) + String(i)
            rightCells[i - 1].havePassed = false
            rightCells[i - 1].isToday = false
            if let clocked = self.clockRecordDict[dateStr] {
                rightCells[i - 1].havePassed = clocked
            }
        }
        
        if calendarMonthAndYear == todayMonthAndYear {
            cells[today + firstWeekDay - 2].isToday = true
        }
    }
    
    var animating : Bool = false
    
    func flipToLastMonthAndYear(monthAndYear:(month:Int, year:Int)){
        if !animating{
            UIView.animateWithDuration(0.3, animations: {[unowned self] () -> Void in
                self.animating = true
                for cell in self.cells{
                    cell.center.x += 245
                }
                }) { (finished:Bool) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        for cell in self.leftCells{
                            cell.center.x += 245
                        }
                        }, completion: { (finished:Bool) -> Void in
                            self.calendarMonthAndYear = monthAndYear

                            for cell in self.cells{
                                cell.center.x -= 245
                            }
                            for cell in self.leftCells{
                                cell.center.x -= 245
                            }
                            self.animating = false
                            
                    })
            }
        }
        
    }
    
    func flipToNextMonthAndYear(monthAndYear:(month:Int, year:Int)){
        if !animating {
            UIView.animateWithDuration(0.3, animations: {[unowned self] () -> Void in
                self.animating = true
                for cell in self.cells{
                    cell.center.x -= 245
                }
                }) { (finished:Bool) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        for cell in self.rightCells{
                            cell.center.x -= 245
                        }
                        }, completion: { (finished:Bool) -> Void in
                            self.calendarMonthAndYear = monthAndYear

                            for cell in self.cells{
                                cell.center.x += 245
                            }
                            for cell in self.rightCells{
                                cell.center.x += 245
                            }
                            self.animating = false
                    })
            }
        }
    }
    
    func frameOfCell(#width:CGFloat, height:CGFloat, dayNumber:Int, firstDay:Int) -> CGRect{
        let x = CGFloat((dayNumber + firstDay - 2) % 7) * width
        let y = CGFloat((dayNumber + firstDay - 2) / 7) * height
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func numberOfDaysInMonthAndYear(monthAndYear:(month:Int, year:Int)) -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.MonthCalendarUnit, fromDate: date) as NSDateComponents
        switch monthAndYear.month{
        case 2:
            let year2 = monthAndYear.year
            if (year2%4 == 0 && !(year2%100 == 0) || year2 % 400 == 0) {
                return 29
            }else{
                return 28
            }
        case 4,6,9,12:
            return 30
        case 1,3,5,7,8,10,11:
            return 31
        default:
            return 0;
        }
    }
    
    func firstWeekDayInMonthAndYear(monthAndYear:(month:Int, year:Int)) -> Int{
        let now = NSDate()
        let unitFlags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: now)
        components.day = 1
        components.month = monthAndYear.month
        components.year = monthAndYear.year
        let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let firstDayDate = gregorian?.dateFromComponents(components)
        let firstDayCompo = NSCalendar.currentCalendar().components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: firstDayDate!)
        return firstDayCompo.weekday
    }
    
    func getToday () -> Int {
        let date = NSDate()
        let compo = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: date)
        return compo.day
    }
}
