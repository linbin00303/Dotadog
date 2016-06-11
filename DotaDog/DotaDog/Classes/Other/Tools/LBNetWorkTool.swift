
//
//  LBNetWorkTool.swift
//  LBAFNetworkingTool
//
//  Created by 林彬 on 16/4/28.
//  Copyright © 2016年 linbin. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

// MARK:- 对请求格式设置成枚举
enum RequestType{
    case GET
    case POST
}

class LBNetWorkTool : AFHTTPSessionManager {
    // MARK:- 将LBNetWorkTool设置成单例
    static let shareNetWorkTool : LBNetWorkTool = {
        let tools = LBNetWorkTool()
        tools.requestSerializer.timeoutInterval = 10
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        tools.responseSerializer.acceptableContentTypes = nil
        return tools
    }()
}

// MARK:- 封装网络工具类函数
extension LBNetWorkTool{
     func request(requestType :RequestType , urlString :String , parameters :[String:AnyObject]? , finished:(result : AnyObject? , error : NSError?) ->()) {
        
        // 成功的闭包
        let successCallBack = {(task:NSURLSessionDataTask, result:AnyObject?) -> Void in
            // 成后执行的程序
            finished(result: result, error: nil)             // 执行闭包,传递参数
        }
        
        // 失败的闭包
        let failureCallBack = {(task : NSURLSessionDataTask?, error : NSError) -> Void in
            // 失败后执行的程序
            finished(result: nil, error: error)
        }
        
        if requestType == .GET {
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else{
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}