//
//  DDogShowZJHeader.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

 /** 当前状态（0：离线 1：在线 2：忙碌 3：离开 4：打盹 5：正在浏览商品 6：正在玩游戏） */


class DDogShowZJHeader: UIView {
    
    var playerModel : DDogPlayerModel? {
        didSet{
            // nil值校验
            guard let _ = playerModel else {
                return
            }
            
            playerIcon.sd_setImageWithURL(NSURL(string: playerModel!.avatarfull), placeholderImage: UIImage(named: "iconPlace"), completed: nil)
            
            name.text = playerModel?.personaname
            // 要减去76561197960265728
            steamID.text = "\(Int64(playerModel!.steamid)! - 76561197960265728)"
            
            switch playerModel!.personastate.integerValue {
            case 0:
                state.text = "离线"
                state.backgroundColor = UIColor.grayColor()
            case 1:
                state.text = "在线"
                state.backgroundColor = UIColor.greenColor()
            case 2:
                state.text = "忙碌"
                state.backgroundColor = UIColor.redColor()
            case 3:
                state.text = "离开"
                state.backgroundColor = UIColor.orangeColor()
            case 4:
                state.text = "打盹"
                state.backgroundColor = UIColor.purpleColor()
            case 5:
                state.text = "浏览商品"
                state.backgroundColor = UIColor.greenColor()
            case 6:
                state.text = "游戏中"
                state.backgroundColor = UIColor.greenColor()                
            default:
                state.text = "未知"
            }
            
            let times = DDogTimeTransform.timeTransUTCtoDate(playerModel!.lastlogoff.integerValue) as String
            lasttime.text = times
            
           
        }
    }
    @IBOutlet weak var playerIcon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var steamID: UILabel!

    @IBOutlet weak var state: UILabel!
    
    @IBOutlet weak var lasttime: UILabel!
    
    class func showZJHeadFromNib() -> DDogShowZJHeader {
        let header = NSBundle.mainBundle().loadNibNamed("DDogShowZJHeader", owner: self, options: nil).last as! DDogShowZJHeader
        
        return header
    }
}
