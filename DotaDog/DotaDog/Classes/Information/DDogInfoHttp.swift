


//
//  DDogInfoHttp.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/1.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogInfoHttp: NSObject {
    func getHomeViewNetData(offset:Int , finished : (result : AnyObject? , error : NSError?) ->()){
        // 1.获取请求的URLString
        let urlString = "http://mobapi.meilishuo.com/2.0/twitter/popular.json"
        
        // 2.获取请求的参数
        let parameters = ["offset" : "\(offset)", "limit" : "30", "access_token" : "b92e0c6fd3ca919d3e7547d446d9a8c2"]
        
        LBNetWorkTool.shareNetWorkTool.request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            
            // 1:判断有没有错误,有就返回错误
            if error != nil {
                finished(result: nil, error: error)
                return
            }
            
            // 2:如果result的类型不是字典,那么报data error错误
            guard let result = result as? [String : AnyObject] else {
                finished(result: nil, error: NSError(domain: "data error", code: -1011, userInfo: nil))
                return
            }
            
            // 3:都没错误,那么返回正常的数据
            // 这里返回的是result这个字典中的data key键对应的值.对应的类型是字典数组
            finished(result: result["data"] as? [[String : AnyObject]], error: nil)
        }
        
    }
}
