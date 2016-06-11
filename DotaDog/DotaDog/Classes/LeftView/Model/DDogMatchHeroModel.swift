


//
//  DDogMatchHeroModel.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogMatchHeroModel: NSObject {
    /** account_id玩家ID */
    var account_id : NSNumber = 0
    
    /** player_slot:玩家阵营（0-4：天辉 >4：夜魇） */
    var player_slot : NSNumber = 0
    
    /** hero_id：所选英雄id */
    var hero_id : NSNumber = 0
 
    /** item_0：物品栏1 */
    var item_0 : NSNumber = 0
    
    /** item_1：物品栏2 */
    var item_1 : NSNumber = 0
    
    /** item_2：物品栏3 */
    var item_2 : NSNumber = 0
    
    /** item_3：物品栏4 */
    var item_3 : NSNumber = 0
    
    /** item_4：物品栏5 */
    var item_4 : NSNumber = 0
    
    /** item_5：物品栏6 */
    var item_5 : NSNumber = 0
    
    /** kills：杀敌数 */
    var kills : NSNumber = 0
    
    /** deaths：死亡数 */
    var deaths : NSNumber = 0
    
    /** assists：助攻数 */
    var assists : NSNumber = 0
    
    /*------------以下是详情数据----------*/
    
    /** last_hits：正补 */
    var last_hits : NSNumber = 0
    
    /** denies：反补 */
    var denies :NSNumber = 0
    
    /** gold_per_min：每分钟金钱 */
    var gold_per_min : NSNumber = 0
    
    /** xp_per_min：每分钟经验 */
    var xp_per_min : NSNumber = 0
    
    /** level：等级 */
    var level : NSNumber = 0
    
    /** hero_damage：对英雄造成的总伤害 */
    var hero_damage : NSNumber = 0
    
    /** hero_healing：总治疗量 */
    var hero_healing : NSNumber = 0
    
    /** tower_damage：对建筑造成的总伤害 */
    var tower_damage : NSNumber = 0
    
    /** gold：当前金钱 */
    var gold : NSNumber = 0
    
    /** gold_spent：总花费金钱 */
    var gold_spent : NSNumber = 0
    
 
    
}
