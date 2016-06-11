//
//  DDogSeachCache.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/19.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogSearchCache: NSObject {

    // 将搜索的关键字拼接成数组保存起来
    class func saveSearchCache(searchText : String , key : String) {
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        var myArray = userDefaultes.arrayForKey(key)
        if myArray?.count > 0 {
            
        }else{
            myArray = [String]()
        }
        
        myArray?.append(searchText)
        if myArray?.count > 5 {
            myArray?.removeAtIndex(0)
        }
        //将上述数据全部存储到NSUserDefaults中
        userDefaultes.setObject(myArray, forKey: key)
        userDefaultes.synchronize()
        
    }
    
   
    
    class func removeAllSearchCache(key : String) {
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        userDefaultes.removeObjectForKey(key)
        userDefaultes.synchronize()
    }
    
    // 将搜索结果的JSON抽出数组保存起来
    class func saveModelCache(player : NSDictionary , key : String) {
        
//        // 把模型存到沙盒中(因为是自定义对象,所以存为plist文件)
//        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
//        let filePath = path!.stringByAppendingString("/playerArr.plist")
//        print(filePath)
//        playerModel.writeToFile(filePath, atomically: true)
        
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        var modelArr = userDefaultes.arrayForKey(key)
        if modelArr?.count > 0 {
            
        }else{
            modelArr = NSArray() as [AnyObject]
        }
        modelArr?.insert(player, atIndex: 0)
//        modelArr?.append(player)
        if modelArr?.count > 5 {
            modelArr?.removeAtIndex(4)
        }
        
        //将上述数据全部存储到NSUserDefaults中
        userDefaultes.setObject(modelArr!, forKey: key)
        userDefaultes.synchronize()
        
    }
}
