//
//  DDogBaseViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/4.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogBaseViewController: UIViewController {

    var leftView = UIView()
    var tabbarView = UIView()
    var tabBarViewController = UITabBarController()
    var coverView = UIView()
    var panCoverView = UIView()
    var panGest = UIPanGestureRecognizer()
 
    // 监听通知
    var observer : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpChildVC()
        setUpGestureRecognizer()
        
    }
    
    deinit{
        // 移除通知的操作
        NSNotificationCenter.defaultCenter().removeObserver(self.observer!)
        self.observer = nil
        
        // 移除KVO
        tabbarView.removeObserver(self, forKeyPath: "frame")
    }
}

extension DDogBaseViewController : UIGestureRecognizerDelegate{
    private func setUpChildVC() {
        let leftVC = DDogLeftViewController()
        self.addChildViewController(leftVC)
        leftVC.view.frame = CGRectMake(-offsetLeftVRight, self.view.y, self.view.width, self.view.height)
        view .addSubview(leftVC.view)
        leftView = leftVC.view
        
        let tabbarVC = DDogTabBarController()
        self.addChildViewController(tabbarVC)
        tabbarVC.view.frame = view.bounds
        tabBarViewController = tabbarVC
        view.addSubview(tabbarVC.view)
        tabbarView = tabbarVC.view
        tabbarView.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        
        let coverV = UIView()
        coverV.frame = self.tabbarView.frame
        coverV.hidden = true
        tabbarView.addSubview(coverV)
        
        coverView = coverV
        let tap = UITapGestureRecognizer(target: self, action: #selector(DDogBaseViewController.tap))
        coverView.addGestureRecognizer(tap)
        
        let panCoverV = UIView()
        panCoverV.frame = CGRectMake(tabbarView.x, tabbarView.y + 100, 60, tabbarView.height - 145)
        tabbarView.addSubview(panCoverV)
        panCoverView = panCoverV
        
        observerHiddenPanCoverViewNotice()
        
    }
    
    func observerHiddenPanCoverViewNotice(){
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName("hiddenPanCoverView", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notfication:NSNotification) -> Void in
            
            if notfication.userInfo!["hidden"] as! Bool == false {
                // 在视频控制器界面隐藏
                self?.panCoverView.hidden = false
            }else {
                // 在其它控制器显示
                self?.panCoverView.hidden = true
            }
            
        }
    }
    
    
    
    @objc private func tap() {
        if self.tabbarView.x != 0 {
            UIView.animateWithDuration(0.25, animations: { 
                self.tabbarView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                self.leftView.frame = CGRectMake(-offsetLeftVRight, self.view.y, self.view.width, self.view.height);
            })
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if tabbarView.x == offsetMainRight {
            panCoverView.hidden = true
            coverView.hidden = false
        } else {
            panCoverView.hidden = false
            coverView.hidden = true
        }
        
    }
    
    private func setUpGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DDogBaseViewController.pan))
        pan.delegate = self
        panGest = pan
        self.panCoverView.addGestureRecognizer(pan)
    }
    
    @objc private func pan(pan:UIPanGestureRecognizer) {
        let transP = pan.translationInView(tabbarView)
        tabbarView.frame = tabFrameWithoffsetX(transP.x)
        pan.setTranslation(CGPointZero, inView: tabbarView)
        
        leftView.frame = leftViewFrameWithoffsetX(transP.x)
        pan.setTranslation(CGPointZero, inView: leftView)
        
        if pan.state == .Ended {
            var targetMain : CGFloat = 0
            var targetLeft : CGFloat = offsetLeftVRight
            if tabbarView.x > ScreenW * 0.5 {
                targetMain = offsetMainRight
                targetLeft = 0
            }
            
            let offsetMainX = targetMain - tabbarView.x
            let offsetLeftX = -targetLeft
            
            UIView.animateWithDuration(0.25, animations: { 
                self.tabbarView.frame = self.tabFrameWithoffsetX(offsetMainX)
                self.leftView.frame = CGRectMake(offsetLeftX, 0, self.view.width, self.view.height)
            })
        }
        
        
    }
    
    
    
    private func tabFrameWithoffsetX(offsetX : CGFloat) ->CGRect{
        var frame = tabbarView.frame
        frame.origin.x += offsetX;
        if frame.origin.x <= 0 { frame.origin.x = 0 }
        
        return frame;
    }
    
    
    private func leftViewFrameWithoffsetX(offsetX : CGFloat) ->CGRect{
        var frame = leftView.frame
        frame.origin.x += (offsetX * offsetLeftVRight / offsetMainRight);
        if frame.origin.x >= 0 { frame.origin.x = 0 }
        return frame;
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let tabVC : DDogTabBarController = self.childViewControllers[1] as! DDogTabBarController
        
        for nav in tabVC.childViewControllers  {
            if nav.isKindOfClass(DDogNavController) {
                if nav.childViewControllers.count > 1 {
//                    self.panCoverView.hidden = true
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK:- 解决手势冲突
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //UILayoutContainerView
//         print("\(otherGestureRecognizer.view)" )
//        UIGestureRecognizerState

        //UITableViewWrapperView
        
        
//        if otherGestureRecognizer.view!.isKindOfClass(NSClassFromString("UITableView")!){
//            let tableV = otherGestureRecognizer.view as! UITableView
//            
//            if tableV.contentOffset.y != 0 {
////                return false
//                gestureRecognizer.enabled = false
//                
//            }else {
////                return true
//            }
//            
//            gestureRecognizer.enabled = true
//        }
        
        if otherGestureRecognizer.view!.isKindOfClass(NSClassFromString("UIScrollView")!){
            let scrollV = otherGestureRecognizer.view as! UIScrollView
            if  scrollV.contentOffset.x <= 0 {
//                scrollV.bounces = false
//                gestureRecognizer.enabled = true
                return true
            }else {
//                gestureRecognizer.enabled = false
                return false
            }
        }
        
       
        
        
        
        return true
        
    }
}



