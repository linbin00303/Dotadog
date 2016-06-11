//
//  DDogInfoFlowLayout.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/1.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogInfoFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        super.prepareLayout()
        
        // 1:定义常量
        let cols : CGFloat = 3
        let margin : CGFloat = 9
        
        // 2:设置item宽高
        let itemW = (UIScreen.mainScreen().bounds.size.width - (cols + 1) * margin) / cols
        let itemH = itemW * 1.17
        
        // 3:设置布局内容
        itemSize = CGSizeMake(itemW, itemH)
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        
        // 4:设置内部偏移量
        collectionView?.contentInset = UIEdgeInsets(top: margin + 64, left: margin, bottom: margin + 45, right: margin)
        
    }
}
