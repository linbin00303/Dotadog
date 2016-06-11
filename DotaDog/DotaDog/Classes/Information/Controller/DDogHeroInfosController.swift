//
//  DDogHeroInfosController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/2.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogHeroInfosController: UIViewController {

    private lazy var heroImageView = UIImageView()
    private lazy var heroInfoWebV = UIWebView()
    var heroName : String?
    var bio :String?
    private lazy var abbilityArr : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let heroWebV = UIWebView()
        heroWebV.frame = view.bounds
        heroInfoWebV = heroWebV
        view.addSubview(heroWebV)
        
        
         getSQLData()
    }
    
    func getSQLData() {
        // 开启子线程进行数据库操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let herosName = self.heroName?.lowercaseString.stringByReplacingOccurrencesOfString("_", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("'", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
            let sql = "SELECT dname,desc,ability,lore,notes FROM ability where hurl = '\(herosName!)'"
            DDogFMDBTool.shareInstance.query_abilityByColumn(sql, finished: { [weak self](results) in
                self?.abbilityArr = DDogHeroInfo.mj_objectArrayWithKeyValuesArray(results!)
            })
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.heroAbilityWithArray(self.abbilityArr)
                self.heroInfoWebV.reload()
            }
        }
    }
    
}

extension DDogHeroInfosController : UIWebViewDelegate {
    func heroAbilityWithArray(abbilityArr : NSMutableArray) {
        
        // 1.1 取出所有的内容
        var abilitysHtml = ""
        for i in 0..<abbilityArr.count {
            let abilityHtml =  "<div id=\"ability\"><div class=\"head\"><img src=\"http://cdn.dota2.com/apps/dota2/images/abilities/\((abbilityArr[i] as! DDogHeroInfo).ability)_hp2.png\"><div class=\"dname\"><p>\((abbilityArr[i] as! DDogHeroInfo).dname)</p></div><div class=\"desc\"><p>\((abbilityArr[i] as! DDogHeroInfo).desc)</p></div></div><div class=\"lore\"><p>\((abbilityArr[i] as! DDogHeroInfo).lore)</p></div><div class=\"notes\"><p>\((abbilityArr[i] as! DDogHeroInfo).notes)</p></div></div>"
            abilitysHtml = abilitysHtml + abilityHtml
        }
        
        let heroInfoHtml = "<div id=\"heroInfo\"><h3>英雄介绍</h3><p>\(bio!)</p></div>"
        
        // 创建CSS样式
        let css = NSBundle.mainBundle().URLForResource("abilitysDetail", withExtension: "css")
        let cssHtml = "<link href=\"\(css!)\" rel=\"stylesheet\" />"
        
        // 创建JS文件
        let js = NSBundle.mainBundle().URLForResource("abilitysDetail", withExtension: "js")
        let jsHtml = "<script src=\"\(js!)\"></script>"
        let html = "<html><head>\(cssHtml)</head><body>\(abilitysHtml)\(heroInfoHtml)\(jsHtml)</body></html>"
        
        // 把取出的内容显示在webView中
        heroInfoWebV.loadHTMLString(html, baseURL: nil)
    }
}
