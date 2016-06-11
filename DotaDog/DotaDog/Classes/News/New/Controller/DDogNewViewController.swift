//
//  DDogNewViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/31.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class DDogNewViewController: UITableViewController {

    private let ID = "new"
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    
    var page = 1
    
    private lazy var newsModelArr : NSMutableArray = {
        let newsModelArr = NSMutableArray()
        return newsModelArr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        DDogNewsHttp.getNewData(1) { [weak self](resultMs) in
            if resultMs == ["error"] {
//                SVProgressHUD.setMinimumDismissTimeInterval(1)
//                SVProgressHUD.showErrorWithStatus("Json数据出错,请刷新")
                return
            }
            
            self?.newsModelArr = resultMs
            self?.tableView.reloadData()
        }
        
        header.setRefreshingTarget(self, refreshingAction:#selector(DDogNewViewController.getNetData))
        tableView.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(DDogNewViewController.getMoreData))
        footer.automaticallyHidden = true
        tableView.mj_footer = footer
        
        tableView.registerNib(UINib(nibName: "DDogNewsCell", bundle: nil), forCellReuseIdentifier: ID)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DDogNewsHttp.getNewData(1) { [weak self](resultMs) in
            if resultMs == ["error"] {
                SVProgressHUD.setMinimumDismissTimeInterval(1)
                SVProgressHUD.showErrorWithStatus("Json数据出错,请刷新")
                return
            }
            
            self?.newsModelArr = resultMs
            self?.tableView.reloadData()
        }
    }
    
    func getNetData() {
        DDogNewsHttp.getNewData(1) { [weak self](resultMs) in
            self?.newsModelArr = resultMs
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    func getMoreData() {
        page = page + 1
        DDogNewsHttp.getNewData(page) { [weak self](resultMs) in
            if resultMs == [] {
                self?.tableView.mj_footer.state = .NoMoreData
                self?.tableView.mj_footer.endRefreshing()
                return
            }
            for i in 0..<resultMs.count {
                self?.newsModelArr.addObject(resultMs[i])
            }
            self?.tableView.reloadData()
            self?.tableView.mj_footer.endRefreshing()
        }
    }

    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsModelArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as! DDogNewsCell
        
        cell.newsModel = newsModelArr[indexPath.row] as? DDogNewsModel

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let contentVC = DDogDetailsViewController()
        contentVC.model = newsModelArr[indexPath.row] as? DDogNewsModel
        self.navigationController?.pushViewController(contentVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
 

}
