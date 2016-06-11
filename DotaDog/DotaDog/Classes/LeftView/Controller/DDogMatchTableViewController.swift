//
//  DDogMatchTableViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/25.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJExtension
import SVProgressHUD

class DDogMatchTableViewController: UITableViewController {

    var j = 0
    
    
    private lazy var playerNames : [String:String]? = {
        let playerNames = [String:String]()
        return playerNames
    }()
    
    var match : DDogMatchListModel?
    
    let MatchHero = "DDogMatchCell"
    
    // 懒加载本场比赛模型
    private lazy var matchModel : DDogMatchModel = {
        let matchModel:DDogMatchModel = DDogMatchModel()
        return matchModel
    }()
    
//    // 懒加载本场比赛英雄模型
//    private lazy var heros : [DDogMatchHeroModel] = {
//        let heros:[DDogMatchHeroModel] = [DDogMatchHeroModel]()
//        return heros
//    }()
    // 懒加载本场比赛英雄模型
    private lazy var heros : NSMutableArray = {
        let heros:NSMutableArray = NSMutableArray()
        return heros
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getNetData()
        
    }
    
    private func setUpTableView() {
        view.backgroundColor = UIColor.blackColor()
        title = "比赛详情"
        // 去掉Cell的间隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
       
        
        // 注册cell
        tableView.registerNib(UINib(nibName: "DDogMatchCell", bundle: nil), forCellReuseIdentifier: MatchHero)
    }



}

// MARK:- 获取网络数据
extension DDogMatchTableViewController{
    private func getNetData() {
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.show()
        
        let matchID = String(format: "%@" , (match?.match_id)!)
        
        let parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "match_id" : matchID]
        DDogLeftViewHttp.getMatchDataByUrl(parameters) { [weak self](resultMs,heroModels,error) -> () in
            
            if resultMs == nil {
                // 服务器大姨妈
                SVProgressHUD.showErrorWithStatus("Steam服务器无法连接")
                return
            }else if resultMs! == []{
                SVProgressHUD.showErrorWithStatus("该用户未公开数据")
                return
            }else if error != nil {
                SVProgressHUD.showErrorWithStatus("网络错误")
            }
            
            self?.matchModel = resultMs!
            // 设置headerView
            let headerV = DDogMatchHeader.showMatchHeadFromNib()
            headerV.matchModle = self?.matchModel
            self?.tableView.tableHeaderView = headerV
            self?.heros = heroModels!
            
            // 获取10个玩家姓名的字典
            let count = heroModels!.count
            var hero : DDogMatchHeroModel?
            for i in 0..<count {
                hero = heroModels![i] as? DDogMatchHeroModel
                self?.getPlayerName(hero!.account_id)
            }
            
            self?.tableView.reloadData()
        }
        
    }
}

extension DDogMatchTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let _ = heros.count
        if heros == [] {
            return 0
        }
        return 5
    }
    
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier(MatchHero, forIndexPath: indexPath) as! DDogMatchCell
        cell.selectionStyle = .None

        var accountID : NSNumber = 0
        if indexPath.section == 0 {
            accountID = (self.heros[indexPath.row] as? DDogMatchHeroModel)!.account_id
            cell.name = playerNames![accountID.stringValue]
            cell.hero = self.heros[indexPath.row] as? DDogMatchHeroModel
        }else {
            accountID = (self.heros[indexPath.row + 5 ] as? DDogMatchHeroModel)!.account_id
            cell.name = playerNames![accountID.stringValue]
            cell.hero = self.heros[indexPath.row + 5 ] as? DDogMatchHeroModel
        }
        return cell
     }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 194
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 25
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text : UILabel = UILabel()
        text.textAlignment = .Center
        text.backgroundColor = UIColor.whiteColor()
        text.textColor = mainColor
        if section == 0 {
            text.text = "天辉"
            return text
        }else {
            text.text = "夜魇"
            return text
        }
    }
    
    func getPlayerName(accountID:NSNumber) {
        
        let tempID = Int64(accountID.intValue) + 76561197960265728
        
        let stringTemp = String(format: "\(tempID)")
        var namedic = [String:String]()
        // 直接用ID查
        let parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "steamids" : stringTemp]
        DDogLeftViewHttp.getPlayerNameByID(parameters) { [weak self](playerNameDic,model,error) in
            
            if error != nil {
                SVProgressHUD.showErrorWithStatus("网络错误")
                return
            }
            if playerNameDic != nil {
                
                namedic = playerNameDic!
                
            }else {
                namedic = [accountID.stringValue : "匿名玩家"]
            }
            self?.playerNames?.updateValue(namedic[accountID.stringValue]!, forKey:accountID.stringValue )
            
            self?.j = self!.j + 1
            if self?.j == 10 {
                SVProgressHUD.dismiss()
                self?.tableView.reloadData()
                self?.j = 0
            }
            
        }
        
    }
    
}
