//
//  DDogLeftViewHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/17.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJExtension

// MARK:- 查询玩家
class DDogLeftViewHttp: NSObject {

    class func getZhanJiNetDataByUrl( parameters : [String : AnyObject] ,tianTiMs : (resultMs : String? , error:NSError?) -> ()) {
        
        LBNetWorkTool.shareNetWorkTool.requestSerializer.timeoutInterval = 5
        
        // 通过URL查
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/", parameters: parameters) { (result, error) -> () in
            
            if let results = result {
                // 判断是不是查到人了
                if Int(results["response"]!!["success"]!! as! NSNumber) != 1 {
                    // 没有查到人
                    tianTiMs(resultMs: nil,error: nil)
                }else {
                    // 查到人,返回steamid
                    tianTiMs(resultMs: String(results["response"]!!["steamid"]!! as! NSString) , error: nil)
                }

            }else {
                tianTiMs(resultMs: "网络错误" , error: error)
            }
            
        }
        
    }
    
    // 通过ID查
    class func getZhanJiNetDataByID( parameters : [String : AnyObject] ,tianTiMs : (resultMs : [DDogPlayerModel]? , playerName : String? ,error:NSError?) -> () ) {
        
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/", parameters: parameters) { (result, error) -> () in
            
            if let results = result {
                // 判断是不是查到人了
                if (results["response"]!!["players"]!! as! [AnyObject] ).count < 1 {
                    // 没有查到人
                    tianTiMs(resultMs: nil ,playerName: nil , error: nil)
                }else {
                    // 查到人,转换成模型
                    let arr = results["response"]!!["players"]!! as! NSArray
                    arr.writeToFile("/Users/linbin/myCode/DotaDog/Plist/player.plist", atomically: true)
                    
                    // 把数据先存到偏好设置里
                    DDogSearchCache.saveModelCache(arr[0] as! NSDictionary, key: "players")
                    
                    // 再获取偏好设置里的所有玩家模型
                    let userDefaultes = NSUserDefaults.standardUserDefaults()
                    //读取数组NSArray类型的数据
                    let temparr = userDefaultes.arrayForKey("players")
                    guard let _ = temparr else {
                        return
                    }
                    let myArray :NSArray? = NSArray(array: temparr!)
                    myArray!.writeToFile("/Users/linbin/myCode/DotaDog/Plist/players.plist", atomically: true)
                    
                    var modelArr : [DDogPlayerModel] = [DDogPlayerModel]()
                    for dic in myArray! {
                        let playerM = DDogPlayerModel(dic: dic as! [String: AnyObject] )
                        modelArr.append(playerM)
                    }
                    
                    // 把转换好的模型数组通过闭包传递出去
                    tianTiMs(resultMs: modelArr , playerName: modelArr[0].personaname,error: nil)
                }
                
            }else {
                // 网络错误
                tianTiMs(resultMs: nil ,playerName: nil , error: error)
            }
            
        }
        
    }
    
    
    // 获取玩家名字和模型
    class func getPlayerNameByID( parameters : [String : AnyObject] ,tianTiMs : (playerNameDic : [String:String]? , playerModel : DDogPlayerModel? , error:NSError?) -> () ) {
        
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/", parameters: parameters) { (result, error) -> () in
            
            if let results = result {
                // 判断是不是查到人了
                if (results["response"]!!["players"]!! as! [AnyObject] ).count < 1 {
                    // 没有查到人
                    tianTiMs(playerNameDic: nil , playerModel: nil ,error: nil)
                }else {
                    // 查到人,转换成模型
                    let arr = results["response"]!!["players"]!! as! NSArray
                    let tempDic = arr[0] as! NSDictionary
                    let model = DDogPlayerModel(dic: arr[0] as! [String : AnyObject])
                    // 把转换好的模型数组通过闭包传递出去
                    let name = tempDic["personaname"] as! String
                    let steamID = Int64(model.steamid)
                    
                    let dict = ["\(steamID! - 76561197960265728)" : name]
                    tianTiMs(playerNameDic: dict , playerModel: model , error: nil)
                }
                
            }else {
                tianTiMs(playerNameDic: nil, playerModel: nil, error: error)
            }
            
        }
        
    }
}

// MARK:- 获取近期比赛列表
extension DDogLeftViewHttp {
    class func getZhanJiListDataByUrl( parameters : [String : AnyObject] ,zhanJiMs : (resultMs : [DDogMatchListModel]? , error:NSError?) -> ()) {
        
        // 通过SteamID查,获得比赛列表
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/", parameters: parameters) { (result, error) -> () in
           
            if result == nil {
                zhanJiMs(resultMs: nil , error: nil)
                return
            }
            
            if let results = result {
                // 判断是不是查到人了
                if Int(results["result"]!!["status"]!! as! NSNumber) != 1 {
                    // 玩家没公开比赛
                    let noPublic = [DDogMatchListModel]()
                    zhanJiMs(resultMs: noPublic , error: nil)
                }else {
                    // 查到比赛,返回模型
                    // 获取字典数组
                    let arr = results["result"]!!["matches"]!! as! NSArray
                    arr.writeToFile("/Users/linbin/myCode/DotaDog/Plist/marchList.plist", atomically: true)
                    // 字典转模型
                    let res : NSMutableArray = DDogMatchListModel.mj_objectArrayWithKeyValuesArray(arr)
                   
                    var tempArr : [DDogMatchListModel] = [DDogMatchListModel]()
                    // 把NSMutableArray转换为[DDogMatchListModel]
                    for item in res {
                        tempArr.append(item as! DDogMatchListModel)
                    }
                    zhanJiMs(resultMs: tempArr, error: nil)
                }
                
            }else{
                zhanJiMs(resultMs: nil, error: error)
            }
            
        }
        
    }
    
    
}

// MARK:- 获取比赛详情
extension DDogLeftViewHttp {
    class func getMatchDataByUrl( parameters : [String : String] ,zhanJiMs : (resultMs : DDogMatchModel?,heroModels:NSMutableArray? , error:NSError?) -> ()) {
        
        // 通过SteamID查,获得比赛列表
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/v1/", parameters: parameters) { (result, error) -> () in
            
//            print(result)
            
            if result == nil {
                zhanJiMs(resultMs: nil ,heroModels: nil , error: nil)
                return
            }
            
            if let result = result {
                // 查到比赛,返回模型
                // 获取字典
                let dic = result["result"]!! as! NSDictionary
                dic.writeToFile("/Users/linbin/myCode/DotaDog/Plist/march.plist", atomically: true)
                // 字典转模型
                let res = DDogMatchModel.mj_objectWithKeyValues(dic)
                let heros = DDogMatchHeroModel.mj_objectArrayWithKeyValuesArray(res.players)
                // 返回比赛数据模型和玩家模型
                zhanJiMs(resultMs: res,heroModels:heros , error:  nil)
            }else{
                zhanJiMs(resultMs: nil
                    , heroModels: nil, error: error)
            }
           
        }
        
    }
    
}
