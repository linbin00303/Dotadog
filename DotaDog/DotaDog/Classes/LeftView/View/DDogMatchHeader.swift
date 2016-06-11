//
//  DDogMatchHeader.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/26.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogMatchHeader: UIView {

    @IBOutlet weak var matchId: UILabel!
  
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var costTime: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    
    var matchModle : DDogMatchModel? {
        didSet{
            // nil值校验
            guard let _ = matchModle else {
                return
            }
            
            matchId.text = matchModle!.match_id.stringValue
            if matchModle!.radiant_win == true {
                result.text = "天辉胜利"
            }else {
                result.text = "夜魇胜利"
            }

            costTime.text = "\(matchModle!.duration.integerValue / 60)" + "分" + "\(matchModle!.duration.integerValue % 60)" + "秒"
            
            let startStr = DDogTimeTransform.timeTransUTCtoDate(matchModle!.start_time.integerValue) as String
            startTime.text = startStr
            
        }
    }
    
    class func showMatchHeadFromNib() -> DDogMatchHeader {
        let header = NSBundle.mainBundle().loadNibNamed("DDogMatchHeader", owner: self, options: nil).last as! DDogMatchHeader
        
        return header
    }
}
