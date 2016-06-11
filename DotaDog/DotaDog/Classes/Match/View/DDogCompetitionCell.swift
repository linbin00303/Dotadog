//
//  DDogCompetitionCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/2.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import CoreLocation

class DDogCompetitionCell: UITableViewCell {
    
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var matchName: UILabel!
    
    @IBOutlet weak var aname: UILabel!

    @IBOutlet weak var bname: UILabel!
    
    @IBOutlet weak var aimg: UIImageView!
    
    @IBOutlet weak var bimg: UIImageView!
    
    @IBOutlet weak var matchState: UILabel!
    
    @IBOutlet weak var action: UIButton!
    
//    var isAcionSelected = false
    
    
    var comModel : DDogCompetitionModel?{
        didSet {
            
            // 先做空值校验.
            guard let competition = comModel else{
                return
            }
            
            startDate.text = competition.showdate + " " + competition.friendlydate
            matchName.text = competition.name
            aname.text = competition.aname
            bname.text = competition.bname
            matchState.text = competition.statusmsg
            aimg.sd_setImageWithURL(NSURL(string: competition.aimg), placeholderImage: UIImage(named: "ddogplace.jpg"))
            bimg.sd_setImageWithURL(NSURL(string: competition.bimg), placeholderImage: UIImage(named: "ddogplace.jpg"))
            
            action.setTitle("", forState: UIControlState.Selected)
            action.setTitle("提醒", forState: UIControlState.Normal)
            action.setImage(UIImage(named: "action_yes"), forState: UIControlState.Selected)
            action.addTarget(self, action: #selector(DDogCompetitionCell.sendNotification), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 按钮的选中状态要从本地开始读
            let userDefaultes = NSUserDefaults.standardUserDefaults()
            if userDefaultes.objectForKey(comModel!.id) == nil {
                
                //将上述数据全部存储到NSUserDefaults中
                userDefaultes.setObject(false, forKey: comModel!.id)
                userDefaultes.synchronize()
            }
            
            let time = NSTimeInterval(floatLiteral: Double(comModel!.startdate)!)
            let time2 = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
//            print(time2)
            if time2 > time {
                userDefaultes.setObject(false, forKey: comModel!.id)
                action.hidden = true
                action.enabled = true
            }
            
            action.selected = userDefaultes.objectForKey(comModel!.id) as! Bool
            
            if competition.statusmsg != "未开始" {
                action.hidden = true
                action.enabled = true
                userDefaultes.removeObjectForKey(comModel!.id)
                userDefaultes.synchronize()
                
            }else {
                action.hidden = false
            }
            
        }
    }
    
    func sendNotification() {
        
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        let isAcionSelected = userDefaultes.objectForKey(comModel!.id) as! Bool
        action.selected = !isAcionSelected
        //将按钮的选中状态更新到NSUserDefaults中
        userDefaultes.setObject(!isAcionSelected, forKey: comModel!.id)
        userDefaultes.synchronize()
        
        
        
        // 1. 创建一个本地通知
        let localNotification = UILocalNotification()
        
        if action.selected == true {
            // 1.1 设置通知的发送时间, 以及发送的内容
            // 触发日期
            let time = NSTimeInterval(floatLiteral: Double(comModel!.startdate)!)
            localNotification.fireDate = NSDate(timeIntervalSince1970: time)
            // 通知的内容
            localNotification.alertBody = "\(matchName!.text!)开始了"
            localNotification.soundName = UILocalNotificationDefaultSoundName

            // 通知的标题, 显示在通知中心的标题
            if #available(iOS 8.2, *) {
                localNotification.alertTitle = "刀塔猎犬"
            }
            
            // 应用程序图标的数字
            localNotification.applicationIconBadgeNumber += 1
            
            // 通知的附加信息
            localNotification.userInfo = [
                "key": "\(matchName!.text!)开始了",
            ]
            // 2. 发送本地通知
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }else {
            for noti : UILocalNotification in UIApplication.sharedApplication().scheduledLocalNotifications!{
                let tempDic = noti.userInfo!
                if tempDic["key"] as! String == "\(matchName!.text!)开始了" {
                    UIApplication.sharedApplication().cancelLocalNotification(noti)
                }
            }
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = UIImageView(image: UIImage(named: "cellBackground_1"))
        imageView.frame = self.contentView.bounds
        self.backgroundView = imageView
    }

   
    
}
