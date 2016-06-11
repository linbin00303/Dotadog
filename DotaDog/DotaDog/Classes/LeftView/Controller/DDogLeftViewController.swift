//
//  DDogLeftViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/11.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

//protocol leftViewDelegate : NSObjectProtocol {
//    func pushToAnyViewController(controller : UIViewController)
//}

class DDogLeftViewController: UIViewController {
    
//    var leftDelegate : leftViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUI()
    }

    private func addUI() {
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 200, ScreenW - offsetLeftVRight, ScreenH - 200))
        backgroundImageView.image = UIImage(named: "leftViewBackground")        
        let leftTableView = UITableView(frame: backgroundImageView.frame, style: UITableViewStyle.Plain)
        
//        leftTableView.backgroundColor = UIColor.clearColor()
        leftTableView.dataSource = self
        leftTableView.delegate = self
        leftTableView.backgroundView = backgroundImageView
        // 去掉底部多余的cell
        leftTableView.tableFooterView = UIView(frame: CGRectZero)
        // 设置为None是为了重画分割线
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.None

        view.addSubview(leftTableView)
        
    }
    
   

}

extension DDogLeftViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = DDogLeftViewTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clearColor()
        // 添加右边小箭头
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        
        // 如果直接设置成.None来禁止cell的选中状态,会导致cell需要重复点击,才能触发didselect方法
        // 所以设置成.Default,添加背景view,设置成clearcolor
        cell.selectionStyle = .Default
        cell.selectedBackgroundView = UIView(frame: cell.bounds)
        cell.selectedBackgroundView?.backgroundColor = UIColor.clearColor()
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = "战绩查询"
            break
        case 1:
            cell.textLabel?.text = "天梯排行"
            break
        case 2 :
            cell.textLabel?.text = "游久dota"
            break
//        case 3:
//            cell.textLabel?.text = "NGA刀塔专区"
//            break
        case 3 :
            cell.textLabel?.text = "扫一扫"
            break
        case 4 :
            cell.textLabel?.text = "清除缓存"
            break
        default :
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller = UIViewController()
        let webController = LBWebViewController()
        
        switch indexPath.row {
        case 0 :

            // 从storyboard中加载控制器
            let storyboard = UIStoryboard(name: "DDogZhanJiViewController", bundle: nil)
            controller = storyboard.instantiateInitialViewController()!
            let pushNav = DDogNavController(rootViewController: controller)
            pushNav.modalPresentationStyle = .Custom
            self.presentViewController(pushNav, animated: true, completion: nil)
            break
        case 1:
            let ttURL = NSURL(string: "http://www.dota2.com.cn/event/201406/ttph/index.htm")
            webController.url = ttURL
            let pushNav = DDogNavController(rootViewController: webController)
            pushNav.modalPresentationStyle = .Custom
            self.presentViewController(pushNav, animated: true, completion: nil)
            break
        case 2 :
            let sgURL = NSURL(string: "http://moba.uuu9.com/forum-4-1.html")
            webController.url = sgURL
            let pushNav = DDogNavController(rootViewController: webController)
            pushNav.modalPresentationStyle = .Custom
            self.presentViewController(pushNav, animated: true, completion: nil)
            break
//        case 3:
//            let ngaURL = NSURL(string: "http://bbs.nga.cn/thread.php?fid=321")
//            webController.url = ngaURL
//            let pushNav = DDogNavController(rootViewController: webController)
//            pushNav.modalPresentationStyle = .Custom
//            self.presentViewController(pushNav, animated: true, completion: nil)
//            break
        case 3 :
            // 从storyboard中加载控制器
            let storyboard = UIStoryboard(name: "DDogGRCodeViewController", bundle: nil)
            controller = storyboard.instantiateInitialViewController()!
            let pushNav = DDogNavController(rootViewController: controller)
            pushNav.modalPresentationStyle = .Custom
            self.presentViewController(pushNav, animated: true, completion: nil)
            break
        case 4 :
            controller = DDogSettingTableViewController()
            let settingNav = DDogNavController(rootViewController: controller)
            settingNav.modalPresentationStyle = .Custom
            self.presentViewController(settingNav, animated: true, completion: nil)
            
            break
        default :
            break
        }
        
    }
    
}

extension DDogLeftViewController {
    private func getFileString()->String{
       let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        
        // 获取SDWebImage缓存尺寸
        let fileSize = LBCleanCache.getDirectorySize(cachePath)
        
        let str = "清除缓存"
        
        // 返回字符串
        var fullStr : NSString = ""
        
        if fileSize > 1000*1000*1000 {
            let size : Double = Double(fileSize) / 1000000000.0
            fullStr = NSString(format: "%@(%.2lfGB)", str,size)
        }else if fileSize > 1000*1000
        {
            let size : Double = Double(fileSize) / 1000000.0
            fullStr = NSString(format: "%@(%.2lfMB)", str,size)
            
        }
        else if fileSize > 1000
        {
            let size : Double  = Double(fileSize) / 1000.0
            fullStr = NSString(format: "%@(%.2lfkB)", str,size)
        }
        else if fileSize > 0
        {
            let size : Double = Double(fileSize)
            fullStr = NSString(format: "%@(%.2lfB)", str,size)
        }
        else{
            //CGFloat size = fileSize / 1000000 ;
            fullStr = "清除缓存"
        }
        return fullStr as String
    }
}