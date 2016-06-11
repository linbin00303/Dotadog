//
//  DDogNewsCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/31.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogNewsCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var dateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = UIImageView(image: UIImage(named: "recommend_forumbg"))
        imageView.frame = self.contentView.bounds
        self.backgroundView = imageView
    }

    
    var newsModel :DDogNewsModel? {
        didSet{
            if newsModel == nil {
                return
            }
            
            self.icon.sd_setImageWithURL(NSURL(string: newsModel!.img), placeholderImage: UIImage(named: "empty_picture"))
            self.title.text = newsModel!.title
            self.content.text = newsModel!.desc
            self.dateTime.text = "发布时间" + newsModel!.posttime
            
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
