//
//  DDogRefreshHeader.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/31.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJRefresh

class DDogRefreshHeader: MJRefreshHeader {

    var textLabel = UILabel()
    
    var loadingView = UIImageView()
    
    override func prepare() {
        super.prepare()
        mj_h = 100
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textAlignment = .Center
        self.addSubview(label)
        textLabel = label
        
        //loading
        let loadingImageCount = 29
        var imageArr = [UIImage]()
        for i in 1...loadingImageCount {
            let image = UIImage(named: "admogoVideo_\(i)")
            imageArr.append(image!)
        }
        let loadingV = UIImageView(image: UIImage(named: "admogoVideo_1"))
        loadingV.contentMode = .ScaleAspectFit
        loadingView = loadingV
        loadingView.animationImages = imageArr
        loadingView.animationDuration = 1
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        textLabel.frame = CGRectMake(0, 70, self.bounds.size.width, 30)
        self.loadingView.bounds = CGRectMake(0, 0, 70, 70)
        self.loadingView.center = CGPointMake(self.bounds.size.width * 0.5, 35)
    }
    
    override var state: MJRefreshState {
        didSet{
            switch state {
            case MJRefreshState.Idle:
                loadingView.stopAnimating()
                textLabel.text = "松开刷新"
                
            case MJRefreshState.Pulling:
                loadingView.stopAnimating()
                textLabel.text = "松开刷新"
                
            case MJRefreshState.Refreshing:
                loadingView.startAnimating()
                textLabel.text = "正在刷新"
                
            case MJRefreshState.WillRefresh:
                loadingView.stopAnimating()
                textLabel.text = "刷新完毕"
                
            default:
                break
            }
        }
    }

}
