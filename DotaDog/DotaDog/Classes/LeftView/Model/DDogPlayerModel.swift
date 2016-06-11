
//
//  DDogPlayerModel.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/20.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogPlayerModel: NSObject {
    
    var steamid : String = ""
    
    /** 头像小图标 32*32 */
    var avatar : String = ""
    
    /** 头像大图标 128*128 */
    var avatarfull : String = ""
    
    /** 头像中图标 64*64 */
    var avatarmedium : String = ""
    
    /** 昵称 */
    var personaname : String = ""
    
    /** 最后上线的时间 */
    var lastlogoff : NSNumber = 0
    
    /** 当前状态（0：离线 1：在线 2：忙碌 3：离开 4：打盹 5：正在浏览商品 6：正在玩游戏） */
    var personastate : NSNumber = 0
    
    /** id创建时间 */
    var timecreated : NSNumber = 0
    
    
    // 利用KVC字典转模型
    override init() {
        super.init()
    }
    
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
