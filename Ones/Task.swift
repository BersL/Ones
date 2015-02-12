//
//  Task.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)

class Task: NSManagedObject {

    @NSManaged var clockRecord: [String:Bool]
    @NSManaged var currentPersist: NSNumber
    @NSManaged var longestPersist: NSNumber
    @NSManaged var plannedDays: NSNumber
    @NSManaged var startDate: NSDate
    @NSManaged var title: String
    @NSManaged var totalPersist: NSNumber

}
