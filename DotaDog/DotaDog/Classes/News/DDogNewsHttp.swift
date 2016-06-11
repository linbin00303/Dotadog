


//
//  DDogNewsHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/31.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogNewsHttp: NSObject {

    class func getNewData( page : Int ,newsMs : (resultMs : NSMutableArray) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "http://dota2box.oss.aliyuncs.com/json/news/newslist_99_\(page).json")
            let jsonStr = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
            if jsonStr == nil {
                newsMs(resultMs: ["error"])
                return
            }
            let data  = jsonStr?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let array = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSMutableArray
            
            if array == nil {
                return
            }
            // 字典转模型
            let modelArr = DDogNewsModel.mj_objectArrayWithKeyValuesArray(array!!)
            
            dispatch_async(dispatch_get_main_queue()) {
                newsMs(resultMs: modelArr)
            }
        }
    }
    
    class func getMatchInfoData( page : Int ,newsMs : (resultMs : NSMutableArray) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "http://dota2box.oss.aliyuncs.com/json/news/newslist_3_\(page).json")
            let jsonStr = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
            if jsonStr == nil {
                newsMs(resultMs: NSMutableArray())
                return
            }
            let data  = jsonStr?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let array = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
            
            // 字典转模型
            let modelArr = DDogNewsModel.mj_objectArrayWithKeyValuesArray(array)
            dispatch_async(dispatch_get_main_queue()) {
                newsMs(resultMs: modelArr)
            }
        }
    }
    
    class func getOfficialData( page : Int ,newsMs : (resultMs : NSMutableArray) -> ()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "http://dota2box.oss.aliyuncs.com/json/news/newslist_1_\(page).json")
            let jsonStr = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
            if jsonStr == nil {
                newsMs(resultMs: NSMutableArray())
                return
            }
            let data  = jsonStr?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let array = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
            
            // 字典转模型
            let modelArr = DDogNewsModel.mj_objectArrayWithKeyValuesArray(array)
            dispatch_async(dispatch_get_main_queue()) {
                newsMs(resultMs: modelArr)
            }
        }
    }
    
    class func getRenovateData( page : Int ,newsMs : (resultMs : NSMutableArray) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "http://dota2box.oss.aliyuncs.com/json/news/newslist_2_\(page).json")
            let jsonStr = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
            if jsonStr == nil {
                newsMs(resultMs: NSMutableArray())
                return
            }
            let data  = jsonStr?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let array = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
            
            // 字典转模型
            let modelArr = DDogNewsModel.mj_objectArrayWithKeyValuesArray(array)
            dispatch_async(dispatch_get_main_queue()) {
                newsMs(resultMs: modelArr)
            }
        }
    }
    
    
}
