

//
//  DDogInfoCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/1.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    
    // 有一个模型属性
    var heroName : String?{
        didSet {
            
            // 先做空值校验.
            guard let name = heroName else{
                return
            }
            let urlStr = "http://www.dota2.com.cn/images/heroes/\(name)_vert.jpg"
            let url = NSURL(string: urlStr)!
            heroImage.setImageWithURL(url, placeholderImage: UIImage(imageLiteral: "empty_picture"))
        }
    }

}
