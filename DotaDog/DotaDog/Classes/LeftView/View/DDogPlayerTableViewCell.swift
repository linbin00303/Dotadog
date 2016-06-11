//
//  DDogPlayerTableViewCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/20.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SDWebImage

class DDogPlayerTableViewCell: UITableViewCell {
    
    var model : DDogPlayerModel?  {
        didSet{
            // nil值校验
            guard let _ = model else {
                return
            }
            
            // 设置头像
            icon.sd_setImageWithURL(NSURL(string: model!.avatarmedium), placeholderImage: UIImage(named: "iconPlace"), completed: nil)
            nickName.text = model!.personaname
            // 在线状态
            currState.text = String(model!.personastate)
            // 注册时间
            let regStr = DDogTimeTransform.timeTransUTCtoDate(model!.timecreated.integerValue) as String
            regTime.text = "注册时间: " + regStr
            // 最后在线时间
            let lastStr = DDogTimeTransform.timeTransUTCtoDate(model!.lastlogoff.integerValue) as String
            lastOnlineTime.text = "最近在线时间: " + lastStr
            
        }
    }
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var currState: UILabel!

    @IBOutlet weak var regTime: UILabel!
    
    @IBOutlet weak var lastOnlineTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
