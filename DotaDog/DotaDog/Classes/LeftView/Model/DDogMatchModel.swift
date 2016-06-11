




//
//  DDogMatchModel.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/23.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogMatchModel: NSObject {

    /** radiant_win:比赛结果（true&false） */
    var radiant_win :Bool = true
    
    /** 比赛ID */
    var match_id : NSNumber = 0
    /** duration:比赛时长 */
    var duration : NSNumber = 0
    
    /** 比赛开始时间 */
    var start_time : NSNumber = 0
    
    /** 玩家比赛英雄数组 */
//    var players : [DDogMatchHeroModel] = [DDogMatchHeroModel]()
    var players : NSMutableArray = NSMutableArray()
}
