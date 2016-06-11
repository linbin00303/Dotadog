//
//  DDogLiveHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/6.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogLiveHttp: NSObject {

    // 获取直播界面模型数组
    class func getLiveData(LiveMs : (livemodels : NSMutableArray? , error:NSError?) -> () ) {
        
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: "http://115.28.43.55/dota2/index.php/Sdk/apiLives", parameters: nil) { (result, error) -> () in
            print(error.debugDescription)
            if error == nil {
                if result == nil { return }
                
                let dicts = result as! NSArray
                let tempArr = DDogLiveModel.mj_objectArrayWithKeyValuesArray(dicts)
                LiveMs(livemodels: tempArr, error: nil)
            }else {
                LiveMs(livemodels: nil, error: error)
            }
            
        }
        
    }
}
