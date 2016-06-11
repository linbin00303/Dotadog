//
//  DDogHeroesAndItemsDataHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/28.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

// MARK:- 处理英雄相关
class DDogHeroesAndItemsDataHttp: NSObject {

    class func handleHeroesInfoData(heroesInfo : (results : NSDictionary?) -> ()) {
        
        // 英雄详细
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://www.dota2.com/jsfeed/heropickerdata?v=3468515b3468515&l=schinese", parameters: nil) { (result, error) -> () in
            
            if result == nil {
                
                return
            }
            // 获取字典
            let dic = result as! NSDictionary
            heroesInfo(results: dic)
            dic.writeToFile("/Users/linbin/myCode/DotaDog/Plist/Hero/herosInfo.plist", atomically: true)
        }
        
        
        //  数组转二进制,然后存入数据库
        //        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Array];
        //        NSKeyedUnarchiver.unarchiveObjectWithData(NSData)
    }
    
    class func handleAbilitysData(abilitys : (results : NSDictionary?) -> ()){
        // 技能详细
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://www.dota2.com/jsfeed/abilitydata?v=3468515b3468515&l=schinese", parameters: nil) { (result, error) -> () in
            
            if result == nil {
                
                return
            }
            
            // 获取字典
            let dic = result!["abilitydata"] as! NSDictionary
            abilitys(results: dic)
            dic.writeToFile("/Users/linbin/myCode/DotaDog/Plist/Abblilty/abilitydata.plist", atomically: true)
        }
    }
    
    
    class func handleHeroesNameENData(heroesName_EN : (results : NSArray?) -> ()){
        // 英雄英文
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=75571F3D1597EA1E8E287E127F7C563F&language=en", parameters: nil) { (result, error) -> () in
            
            if result == nil {
                
                return
            }
            
            // 获取数组
            let arr = result!["result"]!!["heroes"] as! NSArray
            heroesName_EN(results: arr)
            arr.writeToFile("/Users/linbin/myCode/DotaDog/Plist/Hero/heros_EN.plist", atomically: true)
        }
    }
    
    
    class func handleHeroesNameZHData(heroesName_ZH : (results : NSArray?) -> ()){
        // 英雄中文
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=75571F3D1597EA1E8E287E127F7C563F&language=Zh", parameters: nil) { (result, error) -> () in
            
            if result == nil {
                
                return
            }
            
            // 获取数组
            let arr = result!["result"]!!["heroes"] as! NSArray
            heroesName_ZH(results: arr)
            arr.writeToFile("/Users/linbin/myCode/DotaDog/Plist/Hero/heros_ZH.plist", atomically: true)
        }
    }
}

// MARK:- 处理物品相关
extension DDogHeroesAndItemsDataHttp {
    class func handleItemsNameZHData(itemsName_ZH : (results : NSMutableDictionary?) -> ()){
        // 物品
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://www.dota2.com/jsfeed/heropediadata?feeds=itemdata&v=21201034030358593&l=schinese", parameters: nil) { (result, error) -> () in
            
            if result == nil {
                
                return
            }
            
            // 获取数组
            let arr = result!["itemdata"] as! NSMutableDictionary
            itemsName_ZH(results: arr)
            arr.writeToFile("/Users/linbin/myCode/DotaDog/Plist/Hero/items.plist", atomically: true)
        }
    }
}
