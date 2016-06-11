//
//  LBCleanCache.m
//  BuDeJie
//
//  Created by 林彬 on 16/4/7.
//  Copyright © 2016年 linbin. All rights reserved.
//
//   

#import "LBCleanCache.h"

@implementation LBCleanCache

+ (NSInteger)getDirectorySize:(NSString *)directoryPath
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    // 判断全路径是不是文件夹
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果不是是文件夹路径
    if (!isDirectory || !isExist){
        
        // 报错:抛异常
        NSException *excp = [NSException exceptionWithName:@"filePathError" reason:@"please give a directoryPath!" userInfo:nil];
        
        [excp raise];
        
    }
    
    NSArray *subpathArr = [manager subpathsAtPath:directoryPath];
    
    NSInteger totalSize = 0;
    
    for (NSString *subpath in subpathArr) {
        
        // 拼接子文件全路径
        NSString *fullPath =  [directoryPath stringByAppendingPathComponent:subpath];
        
        // 判断全路径是不是文件夹
        BOOL isDirectory;
        BOOL isExist = [manager fileExistsAtPath:fullPath isDirectory:&isDirectory];
        
        // 排除文件夹
        if (!isExist || isDirectory) continue;
        
        // 如果是隐藏文件,跳过隐藏文件
        if ([fullPath containsString:@".DS"]) continue;
        
        // 指定路径获取这个路径的属性
        // attributesOfItemAtPath:只能获取文件属性
        NSDictionary *attr = [manager attributesOfItemAtPath:fullPath error:nil];
        unsigned long long size = [attr fileSize];
        
        totalSize += size;
        
    }
    
    return totalSize;
}

+(void)removeDirectoryPath:(NSString *)directoryPath
{
    
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    // 判断全路径是不是文件夹
    BOOL isDirectory;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果不是是文件夹路径
    if (!isDirectory || !isExist){
        
        // 报错:抛异常
        NSException *excp = [NSException exceptionWithName:@"filePathError" reason:@"please give a directoryPath!" userInfo:nil];
        
        [excp raise];
        
    }
    
    for (NSString *subPath in subpaths) {
        
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }

}

@end
