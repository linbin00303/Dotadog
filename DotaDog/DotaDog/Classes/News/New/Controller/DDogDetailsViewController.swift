//
//  DDogDetailsViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/1.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDogDetailsViewController: UIViewController {

    
    var newsWebView = UIWebView()
    var model : DDogNewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setUpUI()
        
        setUpWebView()
    }

    func setUpUI() {
        self.title = "新闻详情"
        let webView = UIWebView()
        webView.frame = view.bounds
        webView.backgroundColor = UIColor.whiteColor()
        webView.delegate = self
        view.addSubview(webView)
        newsWebView = webView
    }
    
    func setUpWebView() -> () {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "http://dota2box.oss.aliyuncs.com/json/news/content/\(self.model!.id).json")
            let jsonStr = try? NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)

            if jsonStr == nil {
                return
            }
            let data  = jsonStr?.dataUsingEncoding(NSUTF8StringEncoding)
            
            let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            dispatch_async(dispatch_get_main_queue()) {
                self.dealWithNewsDetail(jsonDict!!)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension DDogDetailsViewController: UIWebViewDelegate {
    
    func dealWithNewsDetail(jsonDict: NSDictionary)  {
        // 1.1 取出所有的内容
        let allData = jsonDict["content"]
        // 1.2 取出title
        let title = jsonDict["title"] as! String
        // 1.3 取出来源
        let site = jsonDict["site"] as! String
        // 1.4 取出发布时间
        let ptime = jsonDict["posttime"] as! String
        
        // 创建CSS样式
        let css = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "css")
        let cssHtml = "<link href=\"\(css!)\" rel=\"stylesheet\" />"
        
        // 创建JS文件
        let js = NSBundle.mainBundle().URLForResource("newsDetail", withExtension: "js")
    
        let jsHtml = "<script src=\"\(js!)\"></script>"
        let subTitleHtml = "<div id=\"subTitle\"><span class=\"pTime\">\(ptime)</span><span>\(site)</span></div>"
        let titleHtml = "<div id=\"mainTitle\">\(title)</div>"
        let html = "<html><head>\(cssHtml)</head><body>\(titleHtml)\(subTitleHtml)\(allData!)\(jsHtml)</body></html>"
        
        // 把取出的内容显示在webView中
        newsWebView.loadHTMLString(html, baseURL: nil)
        
    }
    
    
    ///  UIWebViewDelegate  --- 方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取请求的URL字符串
        let urlString: NSString = (request.URL?.absoluteString)!
        // 2.判断处理
        let urlHeader = "ddog://"
        let range = urlString.rangeOfString(urlHeader)
        let location = range.location
        
        if(location != NSNotFound){ // 找到协议头
            // 3.截取出方法名
            let method = urlString.substringFromIndex(range.length)
            // 4.包装成SEL
            let sel = NSSelectorFromString(method)
            // 5.执行SEL
            self.performSelector(sel)
        }
        
        return true;
    }
    
    func modalView() {
        
    }
    
  
}
