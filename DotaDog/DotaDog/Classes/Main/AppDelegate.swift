//
//  AppDelegate.swift
//  DotaDog
//
//  Created by 林彬 on 16/4/27.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import FMDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var leftView : UIView?
    
    private var heroesInfo : NSDictionary?
    private var heroesNameEN : NSArray?
    private var abilitys : NSDictionary?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置根控制器
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let baseVC = DDogBaseViewController()
        window?.rootViewController = baseVC
        window?.backgroundColor = UIColor.blackColor()
        window?.makeKeyAndVisible()
        
        
        
        canConnectToNet { (result) in
            if result == "no"{
                let controller = getAlert("网络状态", message: "未能连接到服务器", doWhat: { (action) in
                })
                    
                baseVC.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        // 发送请求,保存数据到数据库
        saveDataIntoSqlite()
        
        // 非正常启动
        if launchOptions != nil {
            
            if launchOptions![UIApplicationLaunchOptionsLocalNotificationKey] != nil {
                
            }
        }
        
        registerAuthor()
        
        // 测试时间 1464551470
//        let str = DDogTimeTransform.timeTransUTCtoDate(1464921390)
//        print(str)
        
//        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
//        let fullPath = basePath! + "/dotadog.sqlite"
//        print(fullPath)
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        let state = application.applicationState
        
        if state == .Active {
            // 前台
            var dic = notification.userInfo
            let str = dic!["key"] as! String
            let alert = UIAlertView(title: "比赛通知", message: str, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            let navView = window?.rootViewController?.childViewControllers[1].childViewControllers[2] as? DDogNavController
            let matchVC = navView?.childViewControllers[0] as? DDogMatchController
            matchVC?.tableView.reloadData()
            
        }
        if state == .Inactive {
            // 如果当前不在前台, 接收到通知, 要求, 用户点击通知之后, 跳转到会话详情
        }
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // 如果应用程序的图标数字值为0, 就可以隐藏图标数字
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        UIView.setAnimationBeginsFromCurrentState(true)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    private func saveDataIntoSqlite() {
        var herocount : Int32 = 0
        var itemcount : Int32 = 0
        var abilitycount : Int32 = 0
        
        // print(isTableLive("hero"),isTableLive("items"),isTableLive("ability"))
        
        // 开启子线程,进行网络请求和数据存储
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // 如果表都存在,计算每一个表的列数
            if isTableLive("hero")&&isTableLive("items")&&isTableLive("ability") {
                DDogFMDBTool.shareInstance.columnsFromTable("hero") { (result) in
                    herocount = result
                }
                
                DDogFMDBTool.shareInstance.columnsFromTable("items") { (result) in
                    itemcount = result
                }
                
                DDogFMDBTool.shareInstance.columnsFromTable("ability") { (result) in
                    abilitycount = result
                }
            }
            
            if herocount == 111 && itemcount == 189 && abilitycount == 503{
                return
            }
            
            DDogFMDBTool.shareInstance.update_deleteData("hero")
            DDogFMDBTool.shareInstance.update_deleteData("items")
            DDogFMDBTool.shareInstance.update_deleteData("ability")
            
            // 处理英雄数据,网络请求+存入数据库
            DDogHeroesAndItemsDataSync.shareInstance.handleHeroesInfoData { (results) in
            }
            
            // 处理物品数据,网络请求+存入数据库
            DDogHeroesAndItemsDataSync.shareInstance.handleItemsInfoData { (results) in
            }
            
            // 处理完毕,通知主线程
            dispatch_async(dispatch_get_main_queue()) {
            }
        }
    }

}


extension AppDelegate {
    // 一般请求授权的方法, 写在应用程序启动的代理方法里面, 主要是为了刚启动, 就请求用户的权限(此处, 写在这里, 是方便查看代码)
    func registerAuthor() -> () {
        
        // 在ios8.0以后, 如果想要发送本地通知, 需要主动请求授权
        // 另外, 做好版本适配(可以把项目的最低部署版本调低, 让他自动报错修复即可)
        if #available(iOS 8.0, *) {
            
            // 1. 指定需要请求的授权类型(哪些权限,比如弹框, 声音, 图标数字等等)
            let typeValue = UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Badge.rawValue
            let type = UIUserNotificationType(rawValue: typeValue)
            // 2. 根据请求的授权类型, 创建一个通知设置对象
            let setting = UIUserNotificationSettings(forTypes: type, categories: nil)
            
            // 3. 注册通知设置对象(这时, 系统会自动弹出一个授权窗口, 让用户进行授权)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
            
        }
        
    }
    
    
}



