//
//  DDogShowZJViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/19.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDogShowZJViewController: UITableViewController {

    var player : DDogPlayerModel?
    
    let ID = "showZJ"
    
    // 懒加载
    private lazy var matchLists : [DDogMatchListModel] = {
        let matchLists:[DDogMatchListModel] = [DDogMatchListModel]()
        return matchLists
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getNetData()
      
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpTableView() {
        view.backgroundColor = UIColor.blackColor()
        title = "战绩查询"
        // 去掉Cell的间隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // 不让自动下滑64个像素
//        self.automaticallyAdjustsScrollViewInsets = false
        // 设置headerView
        let headerV = DDogShowZJHeader.showZJHeadFromNib()
        headerV.playerModel = player
        tableView.tableHeaderView = headerV
        
        // 注册cell
        tableView.registerNib(UINib(nibName: "DDogShowZJCell", bundle: nil), forCellReuseIdentifier: ID)
    }
   

}

// MARK:- 获取网络数据
extension DDogShowZJViewController{
    private func getNetData() {
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
        print(player!.steamid)
        
        if player == nil {
            return
        }
        
        let parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "account_id" : player!.steamid , "matches_requested" : 10]
        DDogLeftViewHttp.getZhanJiListDataByUrl(parameters as! [String : AnyObject]) { [weak self](resultMs , error) -> () in
            
            if error != nil {
                SVProgressHUD.showErrorWithStatus("网络错误")
                return
            }
            
            if resultMs == nil {
                // 服务器大姨妈
                SVProgressHUD.showErrorWithStatus("Steam服务器错误")
                return
            }else if resultMs! == []{
                SVProgressHUD.showErrorWithStatus("该用户未公开游戏信息")
                return
            }
            
            self?.matchLists = resultMs!
            self?.tableView.reloadData()
        }
        
    }
}

extension DDogShowZJViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchLists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as! DDogShowZJCell
        cell.matchListModel = matchLists[indexPath.row];
        
        // 传递英雄ID
        let temp = Int64(player!.steamid)! - 76561197960265728
        for dict in matchLists[indexPath.row].players {
            if "\(dict["account_id"]!!)" == "\(temp)" {
                cell.heroID = dict["hero_id"]! as? NSNumber
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 点击跳转
        let match = matchLists[indexPath.row]
        let matchVC = DDogMatchTableViewController()
        matchVC.match = match
        self.navigationController?.pushViewController(matchVC, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}


