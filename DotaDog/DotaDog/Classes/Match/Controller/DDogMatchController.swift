//
//  DDogMatchController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

private let ID = "match"

class DDogMatchController: UITableViewController {
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    let backfooter = MJRefreshBackStateFooter()
    
    var lastTime = ""
    
    private lazy var matchModels : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        tableView.separatorStyle = .None
        
        DDogMatchHttp.getMatchNetDataByUrl("0") {[weak self](resultMs) in
            if resultMs == nil {
                return
            }
            
            
            self?.getEarlyStartdate(resultMs!)
            self?.matchModels = resultMs!
            self?.tableView.reloadData()
        }
        
       
        header.setRefreshingTarget(self, refreshingAction:#selector(DDogMatchController.getMoreData))
        header.setTitle("下拉加载更多旧比赛", forState: MJRefreshState.Idle)
        header.setTitle("正在加载...", forState: MJRefreshState.Refreshing)
        header.setTitle("松开加载更多", forState: MJRefreshState.Pulling)
        tableView.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(DDogMatchController.getNetData))
        footer.automaticallyHidden = true
        footer.setTitle("上拉刷新新数据", forState: MJRefreshState.Idle)
        tableView.mj_footer = footer
        
        tableView.registerNib(UINib(nibName: "DDogCompetitionCell", bundle: nil), forCellReuseIdentifier: ID)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.mj_footer.resetNoMoreData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
}

extension DDogMatchController{
    
    func getNetData(){
        DDogMatchHttp.getMatchNetDataByUrl("0") {[weak self](resultMs) in
            
            if resultMs == nil {
                return
            }
            
            self?.getEarlyStartdate(resultMs!)
            self?.matchModels = resultMs!
            self?.tableView.mj_footer.endRefreshing()
            self?.tableView.mj_footer.state = MJRefreshState.NoMoreData
            self?.tableView.reloadData()
        }
        
    }
    
    func getMoreData() {
       
        print(lastTime)
        DDogMatchHttp.getMatchNetDataByUrl(lastTime) { [weak self](resultMs) in
            if resultMs == nil {
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_header.state = MJRefreshState.NoMoreData
                return
            }
            
            // 获取当前数组中最早的startdate
            self?.getEarlyStartdate(resultMs!)
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
     // 获取当前数组中最早的startdate
    func getEarlyStartdate(resultMs : NSMutableArray) {
        let temp = resultMs[0] as! DDogCompetitionModel
        var temp1 = DDogCompetitionModel()
        lastTime = temp.startdate
        for i in 0..<resultMs.count {
            matchModels.insertObject(resultMs[i], atIndex: 0)
            temp1 = resultMs[i] as! DDogCompetitionModel
            if Int64(lastTime)! >= Int64(temp1.startdate)! {
                lastTime = temp1.startdate
            }
        }
    }
}

extension DDogMatchController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as? DDogCompetitionCell
        cell?.selectionStyle = .None
        cell!.comModel = matchModels[indexPath.row] as? DDogCompetitionModel
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    
}
