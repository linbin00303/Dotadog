//
//  LBCleanCache.h
//  BuDeJie
//
//  Created by 林彬 on 16/4/7.
//  Copyright © 2016年 linbin. All rights reserved.
//
//  传入文件夹路径,获取文件夹大小,并且清除文件夹内所有文件(不包含隐藏文件)

#import <Foundation/Foundation.h>

@interface LBCleanCache : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getDirectorySize:(NSString *)directoryPath;


/**
 *  删除文件夹下所有文件
 *
 *  @param directoryPath 文件夹全路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;


@end
