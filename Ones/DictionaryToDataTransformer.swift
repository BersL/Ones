//
//  DictionaryToDataTransformer.swift
//  Ones
//
//  Created by Bers on 15/2/6.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class DictionaryToDataTransformer: NSValueTransformer {
    
    class override func allowsReverseTransformation () -> Bool{
        return true
    }
    
    class override func transformedValueClass() -> AnyClass{
        return NSData.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        return NSKeyedArchiver.archivedDataWithRootObject(value!)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(value as! NSData)
    }
    
}
