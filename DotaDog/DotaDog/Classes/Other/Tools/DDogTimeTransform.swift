//
//  DDogTimeTransform.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/30.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogTimeTransform: NSObject {
    
    class func timeTransUTCtoDate(UTCString:Int)->String{
        let timeStr = NSString(format: "%d", UTCString)
        let time : NSTimeInterval = timeStr.doubleValue
        let data = NSDate(timeIntervalSince1970: time)
        
        let formatter = NSDateFormatter()
//        formatter.dateStyle = NSDateFormatterStyle.FullStyle
//        formatter.timeStyle = NSDateFormatterStyle.FullStyle
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let str:String = formatter.stringFromDate(data)
        return str
    }
}
