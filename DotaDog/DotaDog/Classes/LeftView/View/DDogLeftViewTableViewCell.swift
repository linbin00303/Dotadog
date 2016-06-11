//
//  DDogLeftViewTableViewCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/14.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogLeftViewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 自己重画分割线
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor);
        CGContextFillRect(context, rect);
        
        //上分割线，
        //        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
        //        CGContextStrokeRect(context, CGRectMake(5, -5, rect.size.width - 10, 5));
        //
        //下分割线
        CGContextSetStrokeColorWithColor(context,UIColor.whiteColor().CGColor);
        CGContextStrokeRect(context, CGRectMake(5, rect.size.height - 2, rect.size.width - 10, 1));
    }

}
