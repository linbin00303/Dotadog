//
//  Common.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/10.
//  Copyright © 2016年 linbin. All rights reserved.
//

import Foundation
import UIKit
import FMDB
import AFNetworking

var ScreenW : CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

var ScreenH : CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

var offsetLeftVRight : CGFloat {
    return 90
}

var offsetMainRight : CGFloat {
    return ScreenW - 90
}


// MARK:- 全局颜色
var mainColor : UIColor {
    return UIColor.orangeColor()
}

// MARK:- 随机颜色
var randomColor : UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
}

// MARK:- 灰颜色
var garyColor : UIColor {
    return UIColor(red: 213.0 / 255.0, green: 213.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
}


    
func isTableLive(table : String) -> Bool {
    let queue = DDogFMDBTool.shareInstance.queue
    let sql = "SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?"
    var count : Int32 = 0
    
    queue.inDatabase { (db:FMDatabase!) in
        let resultSet = db.executeQuery(sql, withArgumentsInArray: [table])
        while resultSet.next() {
            count = resultSet.intForColumn("count")
            
        }
    }
    
    return count != 0
}

func canConnectToNet(finished:((result:String) -> ())) -> Void {
    
    var netStatus = ""
    
    
    AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status:AFNetworkReachabilityStatus) in
        switch status {
        case AFNetworkReachabilityStatus.ReachableViaWiFi:
            netStatus = "Wifi"
            finished(result: netStatus)
            break
        case AFNetworkReachabilityStatus.ReachableViaWWAN:
            netStatus = "3G/4G"
            finished(result: netStatus)
            break
        case AFNetworkReachabilityStatus.NotReachable:
            netStatus = "no"
            finished(result: netStatus)
            break
        case AFNetworkReachabilityStatus.Unknown:
            netStatus = "unknown"
            finished(result: netStatus)
            break
            
        }
    }
    
    AFNetworkReachabilityManager.sharedManager().startMonitoring()
    
    
}


func getAlert( title : String?,  message:String? , doWhat:((action : UIAlertAction)->())) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
    
    let doAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
        
        doWhat(action: action)
        
    })
    
    alertController.addAction(cancelAction)
    alertController.addAction(doAction)
    return alertController
}



