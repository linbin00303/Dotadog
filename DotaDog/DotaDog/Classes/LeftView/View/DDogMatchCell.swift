//
//  DDogMatchCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit


class DDogMatchCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var item0: UIImageView!
    
    @IBOutlet weak var item1: UIImageView!
    
    @IBOutlet weak var item2: UIImageView!
    
    @IBOutlet weak var item3: UIImageView!
    
    @IBOutlet weak var item4: UIImageView!
    
    @IBOutlet weak var item5: UIImageView!
    
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var KDA: UILabel!
    
    @IBOutlet weak var heroName: UILabel!
    
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var deniesAndHits: UILabel!
    
    @IBOutlet weak var totalMoney: UILabel!
    
    @IBOutlet weak var expPerM: UILabel!
    
    @IBOutlet weak var tower_damage: UILabel!
    
    @IBOutlet weak var moneyPerM: UILabel!
    
    @IBOutlet weak var heroHeal: UILabel!
    
    @IBOutlet weak var hero_damage: UILabel!
    
    
    var name : String? {
        didSet{
            if name == nil {
                return
            }else {
            // 获取玩家中文名字
            self.playerName.text = name!
            }
        }
    }
    
    var hero : DDogMatchHeroModel? {
        didSet{
            // nil值校验
            guard let _ = hero else {
                return
            }
            
            // 显示物品图标
            let heroItem = [hero!.item_0,hero!.item_1,hero!.item_2,hero!.item_3,hero!.item_4,hero!.item_5]
            let itemViews = [item0,item1,item2,item3,item4,item5]
            showItemIcon(heroItem, itemViews: itemViews)
            
            // 通过英雄ID获得英雄名称和头像
            var sql = "select name_zh from hero where id = \(hero!.hero_id)"
            DDogFMDBTool.shareInstance.query_DataByColumn(sql, targetString: "name_zh") { [weak self](results) in
                self?.heroName.text = results! as? String
            }
            
            sql = "select name_en from hero where id = \(hero!.hero_id)"
            DDogFMDBTool.shareInstance.query_DataByColumn(sql, targetString: "name_en") { [weak self](results) in
                let url = NSURL(string: "http://cdn.dota2.com/apps/dota2/images/heroes/\(results! as! String)_hphover.png")
                self?.icon.sd_setImageWithURL(url)
            }
            
            KDA.text = String(format: "\(hero!.kills)/\(hero!.deaths)/\(hero!.assists)")
            level.text = String(format: "\(hero!.level)级")
            deniesAndHits.text = String(format: "正补:\(hero!.last_hits)  反补:\(hero!.denies)")
            totalMoney.text = String(format: "\((hero!.gold.intValue) + (hero!.gold_spent.intValue))")
            
            expPerM.text = hero!.xp_per_min.stringValue
            tower_damage.text = hero!.tower_damage.stringValue
            moneyPerM .text = hero!.gold_per_min.stringValue
            heroHeal.text = hero!.hero_healing.stringValue
            hero_damage.text = hero!.hero_damage.stringValue
            
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func showItemIcon(heroItems:[NSNumber] , itemViews:[UIImageView!]) {
        let count = itemViews.count
        var sql = ""
        for i in 0..<count {
            let id = heroItems[i]
            sql = "select name from items where id = \(id)"
            DDogFMDBTool.shareInstance.query_DataByColumn(sql, targetString: "name") { (results) in
                if results != nil {
                    let url = NSURL(string: "http://cdn.dota2.com/apps/dota2/images/items/\(results! as! String)_lg.png")
                    
                    itemViews[i].sd_setImageWithURL(url)
                }else{
                    itemViews[i].image = UIImage(named: "nullIcon")
                }
            }
        }
    }

    
}
