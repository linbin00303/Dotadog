//
//  UIImage+LBImage.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    // MARK:- 返回不渲染的图片
    class func imageOriRenderNamed(name : String) -> UIImage{
        let image = UIImage(named: name)

        return image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    // MARK:- 改变图片的size
    class func imageOriginToSize(image : UIImage , size : CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let scaledImage : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return scaledImage;   //返回的就是已经改变的图片
    }
    
    // MARK:- 裁剪出带边框的图片
    class func imageClipWithBorder(borderWidth : CGFloat , boderColor : UIColor , oriImage : UIImage) -> UIImage{
        
        let size : CGSize = CGSizeMake(oriImage.size.width + 2 * borderWidth, oriImage.size.height + 2 * borderWidth);
        UIGraphicsBeginImageContext(size);
        //绘制边框(大圆)
        let path :UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, size.width, size.height))
        boderColor.set()
        path.fill()

        //绘制小圆(把小圆设置成裁剪区域)
        let clipPath : UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(borderWidth, borderWidth, oriImage.size.width, oriImage.size.height))
        clipPath.addClip()
        
        //把图片绘制到上下文当中
        oriImage.drawAtPoint(CGPointMake(borderWidth, borderWidth))
        
        //从上下文当中生成图片
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        //8.关闭上下文.
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}