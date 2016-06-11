//
//  DDogSettingTableViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/10.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDogSettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        setUpNavgationBar()
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpNavgationBar() {
        let button = UIButton(type: .Custom)
        button.setTitle("返回", forState: .Normal)
        button.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Normal)
        button.setTitleColor(mainColor, forState: .Normal)
        button.addTarget(self, action: #selector(DDogSettingTableViewController.back), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = DDogLeftViewTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)

        cell.textLabel?.text = getFileString()
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        cell.selectionStyle = .Default
        cell.selectedBackgroundView = UIView(frame: cell.bounds)
        cell.selectedBackgroundView?.backgroundColor = UIColor.clearColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 清除缓存
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        LBCleanCache.removeDirectoryPath(cachePath)
        
        
        tableView.reloadData()
        SVProgressHUD.showSuccessWithStatus("缓存清理完毕")
    }
    

}

extension DDogSettingTableViewController {
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
