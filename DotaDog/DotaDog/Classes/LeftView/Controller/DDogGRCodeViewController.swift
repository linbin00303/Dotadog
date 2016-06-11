//
//  DDogGRCodeViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/15.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogGRCodeViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var toBottom: NSLayoutConstraint!
    
    @IBOutlet weak var scanLineImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavgationBar()
        
        // 一进入界面就开始扫描
        startScanGR()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        startScanGR()
        startAnimation()
       
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // 当二维码扫描界面dismiss的时候,设置扫描状态为false
        LBQRCodeTool.shareInstance.stopScan()
    }

    func setUpNavgationBar() {
        let button = UIButton(type: .Custom)
        button.setTitle("返回", forState: .Normal)
        button.setImage(UIImage(named: "navigationButtonReturnClick"), forState: .Normal)
        button.setTitleColor(mainColor, forState: .Normal)
        button.addTarget(self, action: #selector(DDogGRCodeViewController.back), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK:- 二维码动画
extension DDogGRCodeViewController {
    // 创建扫描线扫描动画
    func startAnimation() -> (){
        toBottom?.constant = backGroundView.frame.size.height
        self.view.layoutIfNeeded()
        
        toBottom?.constant = -backGroundView.frame.size.height
        UIView.animateWithDuration(2) { [weak self]() -> Void in
            // 无限重复
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self?.view.layoutIfNeeded()
        }
        
    }
    
    func stopAnimation() {
        scanLineImageView.layer.removeAllAnimations()
    }
    
    func startScanGR(){
        let scanQRCode = LBQRCodeTool.shareInstance
        scanQRCode.startScan(view, isDraw: true, interestRect: backGroundView.frame) { [weak self](resultStrs) -> () in
            let GRVC = DDogGRPushViewController()
            if resultStrs.containsString("http://") {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: resultStrs)!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: resultStrs)!)
                }else {
                    GRVC.text = resultStrs
                    self?.navigationController?.pushViewController(GRVC, animated: true)
                }
            }else{
                GRVC.text = resultStrs
                self?.navigationController?.pushViewController(GRVC, animated: true)
            }
            
        }
    }
}
