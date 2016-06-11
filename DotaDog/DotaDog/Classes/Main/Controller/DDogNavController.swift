//
//  DDogNavController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogNavController: UINavigationController {
    var pan : UIPanGestureRecognizer?
    var observer : AnyObject?
    
    override class func initialize() {
        let navBar : UINavigationBar = {
            if #available(iOS 9.0, *) {
                // 获得DDogNavController类及DDogNavController子类的navBar
                let navBar :UINavigationBar = UINavigationBar.appearanceWhenContainedInInstancesOfClasses([self])
                return navBar
            } else {
                let navBar : UINavigationBar = UINavigationBar.appearance()
                return navBar
            }
        }()
        
        UINavigationBar.appearance()
        var attr  = [String : AnyObject]()
        // 加粗字体
        attr[NSFontAttributeName] = UIFont.boldSystemFontOfSize(18)
        attr[NSForegroundColorAttributeName] = mainColor
        navBar.titleTextAttributes = attr
        navBar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), forBarMetrics: .Default)
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // 自己添加全局返回手势
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: interactivePopGestureRecognizer?.delegate, action: Selector("handleNavigationTransition:"))
        view.addGestureRecognizer(pan)
        pan.delegate = self
        self.pan = pan
        // 清空系统手势代理,使用自己的滑动返回手势
        self.interactivePopGestureRecognizer!.enabled = false
        
        observerDisableNotice()
//        observerEnableNotice()
    }

    
    
    func observerDisableNotice() {
//        self.observer = NSNotificationCenter.defaultCenter().addObserverForName("disablePan", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notfication:NSNotification) -> Void in
//            
//            if notfication.userInfo!["isEnable"] as! Bool == false {
//                // 在播放视频的时候禁用全局返回
//                self?.pan?.enabled = false
//                self?.interactivePopGestureRecognizer!.delegate = self
//                self?.interactivePopGestureRecognizer!.enabled = true
//            }else {
//                // 重新启动全局返回
//                self?.pan?.enabled = true
//                self?.interactivePopGestureRecognizer!.enabled = false
//            }
//            
//        }
       
       
        
    }

}



extension DDogNavController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        // 如果是根控制器,不要触发手势
        return self.childViewControllers.count > 1
    }
}

extension DDogNavController {
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            let button = UIButton(type: .Custom)
            button.setTitle("返回", forState: .Normal)
            button.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Normal)
            button.setTitleColor(mainColor, forState: .Normal)
            button.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Highlighted)
            button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(DDogNavController.back), forControlEvents: .TouchUpInside)
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            
            // 隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            
            
        }else {
            let button = UIButton(type: .Custom)
            button.setImage(UIImage(named: "nav_btn_more"), forState: .Normal)
            button.setImage(UIImage(named: "nav_btn_more"), forState: .Highlighted)
            button.addTarget(self, action: #selector(DDogNavController.show), forControlEvents: .TouchUpInside)
            button.sizeToFit()
            button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
           
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            
            
            
        }
        
        super.pushViewController(viewController, animated: animated)
        
    }
    
    @objc func back() {
        self.popViewControllerAnimated(true)
    }
    
    
    
    @objc func show() {
        if self.tabBarController!.view.x == 0 {
            UIView.animateWithDuration(0.25, animations: { 
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                var frame = self.tabBarController!.view.frame
                frame.origin.x = offsetMainRight
                self.tabBarController!.view.frame = frame
                frame.origin.x = 0
                self.tabBarController!.view.superview?.subviews[0].frame = frame
                
            })
        }
        
    }
    
    
}



