//
//  DDogLiveCell.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/6.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogLiveCell: UITableViewCell {
    
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    
    var model : DDogLiveModel?{
        didSet{
            guard let model = model else {
                return
            }
            pic.sd_setImageWithURL(NSURL(string: model.pic), placeholderImage: UIImage(named: "empty_picture"))
            
            img.sd_setImageWithURL(NSURL(string: model.image), placeholderImage: UIImage(named: "empty_picture"))
            
            title.text = model.title
            subtitle.text = model.subtitle
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = UIImageView(image: UIImage(named: "livecellBackground"))
        imageView.frame = self.contentView.bounds
        self.backgroundView = imageView    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override var frame: CGRect{
//        set{
//            frame.origin.x = 5
//            frame.size.width -= 10
////            super.frame = frame
//        }
//        
//        get{
////            let frame = self.frame
//            return super.frame
//        }
//    }
//    
}
