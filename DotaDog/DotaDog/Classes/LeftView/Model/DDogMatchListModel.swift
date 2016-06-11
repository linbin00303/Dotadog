


//
//  DDogMatchListModel.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogMatchListModel: NSObject {
    
    // 匹配模式
    var lobby_type : NSNumber = 0
    
    // 玩家列表
    var players : NSArray = NSArray()
    
    /** 比赛开始时间 */
    var start_time : NSNumber = 0
    
    /** 比赛ID */
    var match_id : NSNumber = 0
}
