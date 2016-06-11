//
//  DDogShowZJCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogShowZJCell: UITableViewCell {

    var heroID :NSNumber? {
        didSet{
            let sql = "select name_en from hero where id = \(heroID!)"
            DDogFMDBTool.shareInstance.query_DataByColumn(sql, targetString: "name_en") { [weak self](results) in
                let url = NSURL(string: "http://cdn.dota2.com/apps/dota2/images/heroes/\(results! as! String)_hphover.png")
                self?.heroIcon.sd_setImageWithURL(url)
            }
        }
    }
    
    
    var matchListModel : DDogMatchListModel? {
        didSet{
            // nil值校验
            guard let _ = matchListModel else {
                return
            }
            
            switch matchListModel!.lobby_type.integerValue {
            case -1:
                lobby_type.text = "无效比赛"
            case 0:
                lobby_type.text = "公开匹配"
            case 1:
                lobby_type.text = "练习赛"
            case 2:
                lobby_type.text = "锦标赛"
            case 3:
                lobby_type.text = "个人匹配"
            case 4:
                lobby_type.text = "人机匹配"
            case 5:
                lobby_type.text = "队伍匹配"
            case 7:
                lobby_type.text = "天梯匹配"
            default:
                lobby_type.text = "未知"
            }
            
            
//            lobby_type.text = matchListModel?.lobby_type.stringValue
            
            let times = DDogTimeTransform.timeTransUTCtoDate(matchListModel!.start_time.integerValue) as String
            time.text = times
        }
    }
    
    @IBOutlet weak var heroIcon: UIImageView!
    
    // 匹配类型
    @IBOutlet weak var lobby_type: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
