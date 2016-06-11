
//
//  DDogVideoController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

private let ID = "Livecell"
class DDogVideoController: UITableViewController {

    
    private lazy var Models : NSMutableArray = {
        let Models = NSMutableArray()
        return Models
    }()
    
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        getNetData()
        SVProgressHUD.show()
        tableView.separatorStyle = .None
        view.backgroundColor = UIColor.orangeColor()
        tableView.registerNib(UINib(nibName: "DDogLiveCell", bundle: nil), forCellReuseIdentifier: ID)
        
        header.setRefreshingTarget(self, refreshingAction:#selector(DDogVideoController.getNetData))
        tableView.mj_header = header
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = false

        // 发送通知,隐藏侧滑手势所在的coverView
        let dic = ["hidden" : true]
        NSNotificationCenter.defaultCenter().postNotificationName("hiddenPanCoverView", object: nil
            , userInfo: dic)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 发送通知,显示侧滑手势所在的coverView
        let dic = ["hidden" : false]
        NSNotificationCenter.defaultCenter().postNotificationName("hiddenPanCoverView", object: nil
            , userInfo: dic)
    }
    
    @objc private func getNetData(){
        DDogLiveHttp.getLiveData {[weak self] (livemodels, error) in
            if error == nil {
                if livemodels == nil {
                    SVProgressHUD.showErrorWithStatus("数据出错,请稍后重试")
                }else {
                    self?.Models = livemodels!
                    SVProgressHUD.dismiss()
                }
            }else {
               SVProgressHUD.showErrorWithStatus("网络出错,请下拉刷新重试")
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            
        }
        
    }
    
}

extension DDogVideoController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Models.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as? DDogLiveCell
        cell?.backgroundColor = UIColor.orangeColor()
        cell?.selectionStyle = .None

        cell?.model = Models[indexPath.row] as? DDogLiveModel
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let model = Models[indexPath.row] as? DDogLiveModel
        let url = model?.playurl
        let title = model?.subtitle
        guard url != nil else {
            return
        }
        
        showLivePlayView(url!, subtitle: title!)
        
    }
}

extension DDogVideoController{
    func showLivePlayView(url : String ,subtitle : String) {
        IJKMoviePlayerViewController.presentFromViewController(self, withTitle: subtitle, URL: NSURL(string: url), isLiveVideo: true, isOnlineVideo: true, isFullScreen: true) {
                // 播放器播放完毕
                print("播放器弹出完毕")
            }
    }
}

extension DDogVideoController{
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

//func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    
//    
//    IJKMoviePlayerViewController.presentFromViewController(self, withTitle: "测试播放", URL: NSURL(string: "http://dlhls.cdn.zhanqi.tv/zqlive/6212_dkhou_1024/index.m3u8"), isLiveVideo: true, isOnlineVideo: true, isFullScreen: true) {
//        // 播放器播放完毕
//        print("播放器弹出完毕")
//    }
//    
//    
//           let player =  IJKMoviePlayerViewController.InitVideoViewFromViewController(self, withTitle: "测试播放", URL: NSURL(string: "http://dlhls.cdn.zhanqi.tv/zqlive/6212_dkhou_1024/index.m3u8"), isLiveVideo: true, isOnlineVideo: true, isFullScreen: true) {
//                // 播放器播放完毕
//                print("播放器弹出完毕")
//            }
//            let vc = DDogShowVidepViewController()
//            vc.view.backgroundColor = UIColor.grayColor()
//            self.navigationController?.pushViewController(vc, animated: true)
//            vc.addChildViewController(player)
//            vc.view.addSubview(player.view)
//    
//    
//            IJKMoviePlayerViewController.pushFromViewController(self.navigationController!, withTitle: "测试播放", URL: NSURL(string: "http://cn-gdyj1-cu.acgvideo.com/vg8/c/b4/7887756-1.flv?expires=1465203600&ssig=FMIX38FtdlulfYuYK5lgpA&oi=456097907&player=1&or=1885007044&rate=0"), isLiveVideo: true, isOnlineVideo: false, isFullScreen: false){
//                // 播放器播放完毕
//                print("播放器弹出完毕")
//            }
//    
//}


 
