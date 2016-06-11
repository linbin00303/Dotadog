//
//  DDogTabBarController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogTabBarController: UITabBarController {
    var tap : UITapGestureRecognizer? = nil
    var pan : UIPanGestureRecognizer = UIPanGestureRecognizer()
    var leftV : UIView?
    
    override class func initialize() {
        // 设置tabbar图标的颜色和字体
        let barItem : UITabBarItem = {
            if #available(iOS 9.0, *) {
                let barItem = UITabBarItem.appearanceWhenContainedInInstancesOfClasses([self])
                return barItem
            } else {
                let barItem = UITabBarItem.appearance()
                return barItem
            }
        }()
        
        var attr = [String : AnyObject]()
        attr[NSForegroundColorAttributeName] = UIColor.orangeColor()
        
        var attrN = [String : AnyObject]()
        attrN[NSFontAttributeName] = UIFont.systemFontOfSize(13)
        
        barItem.setTitleTextAttributes(attr, forState: .Selected)
        barItem.setTitleTextAttributes(attrN, forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAllChildVC()

        setUpAllButtons()
        
        
    }
    // MARK:- 设置所有子控制器
    func setUpAllChildVC() {
        // 主页
        let homeVC : DDogHomeController = DDogHomeController()
        let homeNav  = DDogNavController(rootViewController: homeVC)
        self.addChildViewController(homeNav)
        
        
        // 信息
        // 从storyboard中加载控制器
        let storyboard = UIStoryboard(name: "DDogInfoController", bundle: nil)
        let infoVC : DDogInfoController = storyboard.instantiateInitialViewController()! as! DDogInfoController
        let infoNav = DDogNavController(rootViewController: infoVC)
        self.addChildViewController(infoNav)
        
        // 赛事
        let matchVC : DDogMatchController = DDogMatchController()
        let matchNav = DDogNavController(rootViewController: matchVC)
        self.addChildViewController(matchNav)
        
        // 视频
        let videoVC : DDogVideoController = DDogVideoController()
        let videoNav  = DDogNavController(rootViewController: videoVC)
        self.addChildViewController(videoNav)
        
               
    }
    // MARK:- 设置所有按钮
    func setUpAllButtons() {
        
        let homeNav : DDogNavController = self.childViewControllers[0] as! DDogNavController
        homeNav.tabBarItem.title = "首页"
        homeNav.tabBarItem.image = UIImage.imageOriRenderNamed("tabBar_home_normal")
        homeNav.tabBarItem.selectedImage = UIImage.imageOriRenderNamed("tabBar_home_selected")
        
        
        let infoNav : DDogNavController = self.childViewControllers[1] as! DDogNavController
        infoNav.tabBarItem.title = "信息"
        infoNav.tabBarItem.image = UIImage.imageOriRenderNamed("tabBar_info_normal")
        infoNav.tabBarItem.selectedImage = UIImage.imageOriRenderNamed("tabBar_info_selected")
        
        
        let matchNav : DDogNavController = self.childViewControllers[2] as! DDogNavController
        matchNav.tabBarItem.title = "赛事"
        matchNav.tabBarItem.image = UIImage.imageOriRenderNamed("tabBar_match_click_icon")
        matchNav.tabBarItem.selectedImage = UIImage.imageOriRenderNamed("tabBar_match_click_icon_selected")
    
        let videoNav : DDogNavController = self.childViewControllers[3] as! DDogNavController
        videoNav.tabBarItem.title = "直播"
        videoNav.tabBarItem.image = UIImage.imageOriRenderNamed("tabBar_video_normal")
        videoNav.tabBarItem.selectedImage = UIImage.imageOriRenderNamed("tabBar_video_selected")
        
    }
}

