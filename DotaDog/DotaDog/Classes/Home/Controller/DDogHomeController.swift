

//
//  DDogHomeController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
protocol homeDelegate : NSObjectProtocol {
    func getMainSCVEnabled(isEnable : Bool)
}

class DDogHomeController: UIViewController {

    var delegate : homeDelegate?
    var tranP : CGPoint?
    
    var titleSCV = UIScrollView()
    var mainSCV = UIScrollView()
    var isInital : Bool = false
    var buttonArr  = [UIButton]()
    var preButton = UIButton()
    var underLineView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = randomColor
        // 取消系统自动为导航控制器预留的64高度,避免错位
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.title = "首页"
        
        // 加载主页面
        setUpChildVC()
        
        // 添加标题栏
        setUpTitleScrollView()
        
        // 添加内容滚动条
        setUpMainScrollView()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isInital == false {
            addTitleButtons()
            
            addTitleUnderLine()
            
            self.isInital = true
        }
    }
    
}


extension DDogHomeController {
    // MARK:- 添加子控制器
    private func setUpChildVC() {
        let newTVC = DDogNewViewController()
        newTVC.title = "新闻资讯"
        self.addChildViewController(newTVC)
        
        let matchInfoTVC = DDogMatchInfoViewController()
        matchInfoTVC.title = "赛事新闻"
        self.addChildViewController(matchInfoTVC)
        
        let officialTVC = DDogOfficialViewController()
        officialTVC.title = "热点新闻"
        self.addChildViewController(officialTVC)
        
        let renovateTVC = DDogRenovateViewController()
        renovateTVC.title = "更新公告"
        self.addChildViewController(renovateTVC)
        
        
    }
    // MARK:- 添加标题滚动视图
    private func setUpTitleScrollView() {
        let titleSCV = UIScrollView()
        let y : CGFloat = self.navigationController!.navigationBarHidden ? 20.0 : 64.0
        titleSCV.frame = CGRectMake(0, y, ScreenW, 45)
        titleSCV.backgroundColor = UIColor.whiteColor()
        self.titleSCV = titleSCV
        self.view .addSubview(titleSCV)
        
    }
    // MARK:- 添加内容滚动视图
    private func setUpMainScrollView() {
        let count = self.childViewControllers.count
        let mainSCV = UIScrollView()
        let y = CGRectGetMaxY(self.titleSCV.frame)
        mainSCV.frame = CGRectMake(0, y, ScreenW, ScreenH - y - 49)
        mainSCV.showsHorizontalScrollIndicator = false
        mainSCV.showsVerticalScrollIndicator = false
        // 其他设置
        mainSCV.contentSize = CGSizeMake(CGFloat(count) * mainSCV.width, 0)
        mainSCV.pagingEnabled = true
        mainSCV.bounces = false
        mainSCV.delegate = self
//        mainSCV.scrollEnabled = false
        self.view.addSubview(mainSCV)
        self.mainSCV = mainSCV
    }
    
    
    
    // MARK:- 添加标题滚动视图中的按钮
    private func addTitleButtons() {
        let count = self.childViewControllers.count
        let btnW = ScreenW / CGFloat(count)
        let btnH : CGFloat = 45
        let btnY : CGFloat = 0
        var btnX : CGFloat = 0
        for i in 0  ..< count  {
            let button = UIButton(type: .Custom)
            button.tag = i
            btnX = CGFloat(i) * btnW
            button.frame = CGRectMake(btnX, btnY, btnW, btnH)
            button.setTitleColor(garyColor, forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.setTitle(self.childViewControllers[i].title, forState: .Normal)
            button.addTarget(self, action: #selector(DDogHomeController.buttonClick(_:)), forControlEvents: .TouchUpInside)
            self.titleSCV.addSubview(button)
            self.buttonArr.append(button)
            // 默认点中"新闻资讯"
            if i == 0 {
                buttonClick(button)
            }
        }
        
        self.titleSCV.contentSize = CGSizeMake(CGFloat(count) * btnW, 0)
        self.titleSCV.showsHorizontalScrollIndicator = false
 
    }
    
    // MARK:- 添加标题滚动视图中的下划线
    private func addTitleUnderLine() {
        // 获取第一个按钮.因为一开始就是选中的第一个按钮.要的是这个按钮的颜色,文字宽度
        let firstButton = self.buttonArr.first
        
        let underLineView = UIView()
        let underLineH : CGFloat = 2
        let underLineY : CGFloat = self.titleSCV.height - underLineH
        underLineView.frame = CGRectMake(0, underLineY, 0, underLineH)
        underLineView.backgroundColor = firstButton?.titleColorForState(.Normal)
        self.titleSCV.addSubview(underLineView)
        self.underLineView = underLineView
       
        firstButton?.titleLabel?.sizeToFit()
        self.underLineView.width = (firstButton?.titleLabel?.width)! + 10
        self.underLineView.centerX = (firstButton?.centerX)!
        
    }
    
}

extension DDogHomeController {
    // MARK:- 按钮点击事件
    @objc func buttonClick(curButton : UIButton) {
        
        // 恢复上一个按钮选中标题的颜色
        self.preButton.setTitleColor(garyColor, forState: .Normal)
        self.preButton.transform = CGAffineTransformIdentity
        curButton.setTitleColor(mainColor, forState: .Normal)
        self.preButton = curButton
        
        // 点击的时候,对文字也进行缩放
        // 标题缩放
        curButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
        
        // 获取点击按钮的角标
        let index = curButton.tag
        
        // 添加动画
        UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
            
            // 按钮点击的时候,下划线位移
            // 做下划线的滑动动画
            self?.underLineView.width = curButton.titleLabel!.width + 10
            //        self.underLineView.centerX = currentButton.centerX;
            // 点击按钮,切换对应角标的子控制器的view
            self?.changeChildVCInMainSCV(index)
            // 让内容滚动条滚动对应位置,就是"直播"出现在第一个位置
            let x = CGFloat(index) * ScreenW;
            // 获得偏移量
            self?.mainSCV.contentOffset = CGPointMake(x, 0);
            
            }) { [weak self](finished : Bool) -> Void in
            // 动画结束的时候,加载控制器(方便实现懒加载)
            self?.addCurrentChildView(index)
        }
        
    }
    
    // MARK:- 切换子界面
    private func changeChildVCInMainSCV(index : NSInteger) {
        let x : CGFloat = CGFloat(index) * ScreenW
        self.mainSCV.contentOffset = CGPointMake(x, 0)
    }
    
    // MARK:- 添加子界面
    private func addCurrentChildView(index : NSInteger) {
        let vc = self.childViewControllers[index]
        if vc.view.superview != nil {
            return
        }
        
        let x :CGFloat = CGFloat(index) * ScreenW
        vc.view.frame = CGRectMake(x, 0, ScreenW, self.mainSCV.height)
        self.mainSCV.addSubview(vc.view)
        
    }
}

extension DDogHomeController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取当前偏移量和屏幕宽度的商,就是角标
        let i = Int(scrollView.contentOffset.x / ScreenW)
        
        // 根据对应的角标,获得对应的按钮
        let button = self.buttonArr[i]
        
        // 调用按钮选中方法.
        // 就相当于滚动完毕后,调用了标题的按钮点击事件.
        self.buttonClick(button)
        
        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x > 0 {
//            print("111")
//            scrollView.scrollEnabled = true
        }else {
//            print("222")
//            scrollView.scrollEnabled = false
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
//        print("333")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("444")
//        print(decelerate)
    }
    

  
    
    
    
   

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        // 解决手势冲突
//        if scrollView.contentOffset.x > 0 {
//            scrollView.scrollEnabled = true
////            delegate?.getMainSCVEnabled(true)
//        }else if scrollView.contentOffset.x == 0{
//            /* 
//            
//            新思路:在==0的时候,scrollEnabled = false,添加轻扫手势.左扫点击第二个标题按钮
//            可尝试
//            
//            */
//            scrollView.scrollEnabled = false
//            if tranP?.x > 0 {
//                scrollView.scrollEnabled = false
//                delegate?.getMainSCVEnabled(false)
//            }else {
//                scrollView.scrollEnabled = true
//                delegate?.getMainSCVEnabled(true)
//            }
//        }else  {
//            scrollView.scrollEnabled = false
//            delegate?.getMainSCVEnabled(false)
//        }

        
        changeColor(scrollView)
        changeText(scrollView)
        // 下划线随内容scrollView的滚动而滚动,发生位移
        // CGAffineTransformMakeTranslation 方法
        // 左滑: 0到1;
        // 右滑: 0到-1;
        
        let offset = scrollView.contentOffset.x / ScreenW;
        
        let btn = self.buttonArr.first;
        
        self.underLineView.transform = CGAffineTransformMakeTranslation(offset * btn!.width, 0);
    }
}

// MARK:- 颜色和字体的渐变
extension DDogHomeController {
    private func changeColor(scrollView : UIScrollView) {
        
        let leftI = Int(scrollView.contentOffset.x / ScreenW)
        // 获取左边按钮
        let leftButton = self.buttonArr[leftI]
        
        // 获取右边按钮 6
        let rightI = leftI + 1
        var rightButton = UIButton()
        if  rightI < buttonArr.count  {
            rightButton = buttonArr[rightI]
        }
        
        // 获取缩放比例
        // 0 ~ 1 => 1 ~ 1.2
        let rightScale : CGFloat = scrollView.contentOffset.x / ScreenW - CGFloat(leftI)
        
        let leftScale = 1 - rightScale
        
        // 左滑,leftScale是 从 1 到 0,再变回1 ;rightScale 是从 0 到 1,再变回0
        
        // 右滑,leftScale是 从 0 到 1,       ;rightScale 是从 1 到 0
        /*
        左滑的时候,leftButton 是从 红到灰 ,rightButton是从灰到红.
        右滑的时候,leftButton 是从 灰到红 ,rightButton是从红到灰.
        255  107  0
        */
        let redR = (213 + 32 * (1 - leftScale)) / 255.0
        let greenR = (213 - 108 * (1 - leftScale)) / 255.0
        let blueR = (213 - 213 * (1 - leftScale)) / 255.0
        let rightColor = UIColor(red: redR, green: greenR, blue: blueR, alpha: 1)
        rightButton.setTitleColor(rightColor, forState: .Normal)
        
        let redL = (255 - 32 * (rightScale)) / 255.0
        let greenL = (107 + 108 * (rightScale)) / 255.0
        let blueL = (0 + 213 * (rightScale)) / 255.0
        let leftColor = UIColor(red: redL, green: greenL, blue: blueL, alpha: 1)
        leftButton.setTitleColor(leftColor, forState: .Normal)
        
    }
    
    private func changeText(scrollView : UIScrollView) {
        let leftI = Int(scrollView.contentOffset.x / ScreenW)
        // 获取左边按钮
        let leftButton = self.buttonArr[leftI]
        
        // 获取右边按钮 6
        let rightI = leftI + 1
        var rightButton = UIButton()
        if rightI < buttonArr.count {
            rightButton = buttonArr[rightI];
        }
        
        // 获取缩放比例
        // 0 ~ 1 => 1 ~ 1.3
        let rightScale = scrollView.contentOffset.x / ScreenW - CGFloat(leftI);
        
        let leftScale = 1 - rightScale;
        
        // 对标题按钮进行缩放 1 ~ 1.3
        leftButton.transform = CGAffineTransformMakeScale(leftScale * 0.2 + 1, leftScale * 0.2 + 1);
        rightButton.transform = CGAffineTransformMakeScale(rightScale * 0.2 + 1, rightScale * 0.2 + 1);
    }
}

extension DDogHomeController{
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

extension DDogHomeController {
 
}