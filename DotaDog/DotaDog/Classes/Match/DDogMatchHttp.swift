//
//  DDogMatchHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/2.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJExtension

class DDogMatchHttp: NSObject {
    class func getMatchNetDataByUrl( time : String , matchMs : (resultMs : NSMutableArray?) -> ()) {
        
            LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://api.live.uuu9.com/Index/deafult.html?cid=1&lastdate=\(time)&t=1&k=", parameters: nil) { (result, error) -> () in
            
                if result == nil {
                    matchMs(resultMs: nil)
                    return
                }
                let tempArr = result!["output"] as! NSArray
                let models = DDogCompetitionModel.mj_objectArrayWithKeyValuesArray(tempArr)
                matchMs(resultMs: models)
            
        }
        
    }
}
