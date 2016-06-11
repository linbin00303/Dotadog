//
//  UIImage+LBImage.m
//  彩票
//
//  Created by 林彬 on 16/3/5.
//  Copyright © 2016年 linbin. All rights reserved.
//

#import "UIImage+LBImage.h"

@implementation UIImage (LBImage)

// 添加类扩展,返回的是未被渲染的图片
+ (UIImage *)imageOriRenderNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    
    // 返回不渲染的图片
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

@end
