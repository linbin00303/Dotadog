//
//  DDogHeroesAndItemsDataSync.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/28.
//  Copyright © 2016年 linbin. All rights reserved.
//
// 同步获取数据

import UIKit
import Foundation

class DDogHeroesAndItemsDataSync: NSObject {
    
    private lazy var heroesInfo : NSMutableDictionary = {
        let heroesInfo = NSMutableDictionary()
        return heroesInfo
    }()
    
    private var heroesNameEN : NSMutableArray = {
        let heroesNameEN = NSMutableArray()
        return heroesNameEN
    }()
    
    private var heroesNameZH : NSMutableArray = {
        let heroesNameZH = NSMutableArray()
        return heroesNameZH
    }()
    
    private var abilitys : NSMutableDictionary = {
        let abilitys = NSMutableDictionary()
        return abilitys
    }()
    
    private var items : NSMutableDictionary = {
        let items = NSMutableDictionary()
        return items
    }()
    
    // 单例
    static let shareInstance = DDogHeroesAndItemsDataSync()
    
    // MARK:- 从网络获取英雄信息
    func handleHeroesInfoData(isFinish : (results : Bool) -> ()){
       
        //创建NSURL对象
        var urlString:String="http://www.dota2.com/jsfeed/heropickerdata?v=3468515b3468515&l=schinese"
        var url:NSURL! = NSURL(string:urlString)
        //创建请求对象
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        request.timeoutInterval = 10
        let session = NSURLSession.sharedSession()
        
        var semaphore = dispatch_semaphore_create(0)
        
        var dataTask = session.dataTaskWithRequest(request,completionHandler: {[weak self](data, response, error) -> Void in
            
            if error != nil{
                print(error?.code)
                print(error?.description)
            }else{
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                
                self?.heroesInfo = dict!
//                print(self.heroesInfo)
                
            }
            
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//        print("heroesInfo数据加载完毕！")
        
        //---------------------------------------------------------------------
        urlString = "http://www.dota2.com/jsfeed/abilitydata?v=3468515b3468515&l=schinese"
        url = NSURL(string:urlString)
        //创建请求对象
        let request1 : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request1.HTTPMethod = "GET"
        request1.timeoutInterval = 10
        semaphore = dispatch_semaphore_create(0)
        
        dataTask = session.dataTaskWithRequest(request1,completionHandler: {[weak self](data, response, error) -> Void in
            
            if error != nil{
//                print(error?.code)
//                print(error?.description)
            }else{
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                self?.abilitys = dict!["abilitydata"] as! NSMutableDictionary
//                print(self.abilitys)
                
            }
            
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        print("abilitys数据加载完毕！")
        
        //---------------------------------------------------------------------
        urlString = "https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=75571F3D1597EA1E8E287E127F7C563F&language=en"
        url = NSURL(string:urlString)
        let request2 : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request2.HTTPMethod = "GET"
        request2.timeoutInterval = 10
        semaphore = dispatch_semaphore_create(0)
        
        dataTask = session.dataTaskWithRequest(request2,completionHandler: {[weak self](data, response, error) -> Void in
            
            if error != nil{
//                print(error?.code)
//                print(error?.description)
            }else{
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                self?.heroesNameEN = dict!["result"]!["heroes"] as! NSMutableArray
//                print(self.heroesNameEN)
                
            }
            
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        print("heroesNameEN数据加载完毕！")
        
        //---------------------------------------------------------------------
        urlString = "https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=75571F3D1597EA1E8E287E127F7C563F&language=Zh"
        url = NSURL(string:urlString)
        let request3 : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request3.HTTPMethod = "GET"
        request3.timeoutInterval = 10
        semaphore = dispatch_semaphore_create(0)
        
        dataTask = session.dataTaskWithRequest(request3,completionHandler: {[weak self](data, response, error) -> Void in
            
            if error != nil{
//                print(error?.code)
//                print(error?.description)
            }else{
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                self?.heroesNameZH = dict!["result"]!["heroes"] as! NSMutableArray
                
            }
            
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//        print("heroesNameZH数据加载完毕！")
        
        isFinish(results: true)
        
        // 把英雄数据添加到数据库中
        saveHeroesInfoIntoSqlite { (results) in
            
        }
        
        // 把物品数据添加到数据库中
        saveAbilitysInfoIntoSqlite { (results) in
            
        }
        
    }
    
    // MARK:- 从网络获取物品信息
    func handleItemsInfoData(isFinish : (results : Bool) -> ()){
        //---------------------------------------------------------------------
        let urlString = "http://www.dota2.com/jsfeed/heropediadata?feeds=itemdata&v=21201034030358593&l=schinese"
        let url = NSURL(string:urlString)
        let request4 : NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request4.HTTPMethod = "GET"
        request4.timeoutInterval = 10
        let semaphore = dispatch_semaphore_create(0)
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithRequest(request4,completionHandler: {[weak self](data, response, error) -> Void in
            
            if error != nil{
//                print(error?.code)
//                print(error?.description)
            }else{
                let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
                self?.items = dict!["itemdata"] as! NSMutableDictionary
                
            }
            
            dispatch_semaphore_signal(semaphore)
        }) as NSURLSessionTask
        
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//        print("ItemsInfo数据加载完毕！")
        
        isFinish(results: true)
        
        
        // 把物品信息添加到数据库中
        saveItemsInfoIntoSqlite { (results) in
            
        }
    }
    
}





// MARK:- 数据库操作
extension DDogHeroesAndItemsDataSync {
    func saveHeroesInfoIntoSqlite(isFinish : (results : Bool) -> ()){
        // 创建表
        DDogFMDBTool.shareInstance.update_createHeroesTable()
        
        // 获取数据
        let count = self.heroesNameEN.count
        var id = 0
        var localized_name = ""
        var name_en = ""
        var name_zh = ""
        var tempStr : String = ""
        var atk = ""
        var bio = ""
        var roles : NSArray = []
        var data : NSData = NSData()
        for i in 0..<count {
            id = heroesNameEN[i]["id"] as! Int
            localized_name = heroesNameEN[i]["localized_name"] as! String
            // 做截取处理
            tempStr = heroesNameEN[i]["name"] as! String
            let endIndex = tempStr.startIndex.advancedBy(14)
            name_en = tempStr.substringFromIndex(endIndex)
            
            name_zh = heroesInfo[name_en]!["name"] as! String
            atk = heroesInfo[name_en]!["atk_l"] as! String
            bio = heroesInfo[name_en]!["bio"] as! String
            // 数组,转换为NSData存储
            roles = heroesInfo[name_en]!["roles_l"] as! NSArray
            data = NSKeyedArchiver.archivedDataWithRootObject(roles)
            
//            let image = UIImage(named: "iconPlace")
//            let imageData = UIImagePNGRepresentation(image!)!
            
            let arr = [id,localized_name,name_en,name_zh,atk,bio,data]
            let sql = "INSERT INTO hero(id, localized_name, name_en, name_zh, atk, bio, roles) VALUES(?, ?, ?, ?, ?, ? ,?)"
            
            DDogFMDBTool.shareInstance.update_insertHeroData(sql, objs: arr)
        }
        
    }
    
    
    
    func saveAbilitysInfoIntoSqlite(isFinish : (results : Bool) -> ()){
        // 创建表
        DDogFMDBTool.shareInstance.update_createAbilitysTable()
        var ability = ""
        var tempDict = NSDictionary()
        var affects = ""
        var attrib = ""
        var cmb = ""
        var desc = ""
        var dname = ""
        var hurl = ""
        var lore = ""
        var notes = ""
 
        for key in abilitys.allKeys
        {
            ability = key as! String
            tempDict = abilitys[ability] as! NSDictionary
            
            affects = tempDict["affects"] as! String
            attrib = tempDict["attrib"] as! String
            cmb = tempDict["cmb"] as! String
            desc = tempDict["desc"] as! String
            dname = tempDict["dname"] as! String
            hurl = (tempDict["hurl"] as! String).lowercaseString.stringByReplacingOccurrencesOfString("_", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("'", withString: "")
            lore = tempDict["lore"] as! String
            notes = tempDict["notes"] as! String
            
            let arr = [ability,affects,attrib,cmb,desc,dname,hurl,lore,notes]
            let sql = "INSERT INTO ability(ability,affects, attrib, cmb, desc, dname, hurl, lore, notes) VALUES(?,?, ?, ?, ?, ?, ? ,? ,?)"
            
            DDogFMDBTool.shareInstance.update_insertAbilitysData(sql, objs: arr)
        }
    }
    
    
    func saveItemsInfoIntoSqlite(isFinish : (results : Bool) -> ()){
        // 创建表
        DDogFMDBTool.shareInstance.update_createItemsTable()
        
        var name = ""
        var tempDict = NSDictionary()
        var id = 0
        var dname = ""
        var img = ""
        var cost = 0
        var desc = ""
        var notes = ""
        var lore = ""
        var created = false
        
        for key in items.allKeys
        {
            name = key as! String
            
            tempDict = items[name] as! NSDictionary
            dname = tempDict["dname"] as! String
            img = tempDict["img"] as! String
            desc = tempDict["desc"] as! String
            cost = tempDict["cost"] as! Int
            id = tempDict["id"] as! Int
            notes = tempDict["notes"] as! String
            lore = tempDict["lore"] as! String
            created = tempDict["created"] as! Bool
            let arr = [id,name,dname,img,cost,desc,notes,lore,created]
            
            let sql = "INSERT INTO items(id, name, dname, img, cost, desc, notes, lore, created) VALUES(?, ?, ?, ?, ?, ? ,? ,? ,?)"
            
            DDogFMDBTool.shareInstance.update_insertItemsData(sql,objs: arr as [AnyObject])
        }
        
    }
}
