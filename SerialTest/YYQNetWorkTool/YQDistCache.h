//
//  YQDistCache.h
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQDistCache : NSObject

/**
 将数据写入磁盘

 @param data 数据
 @param directory 目录
 @param fileName 文件名
 */
+ (void)writeData:(id)data toDir:(NSString *)directory fileName:(NSString *)fileName;


/**
 从磁盘读取数据

 @param directory 目录
 @param fileName 文件名
 */
+ (id)readDataFromDir:(NSString *)directory fileName:(NSString *)fileName;


/**
 获取目录中文件总大小

 @param directory 目录名
 @return 文件总大小
 */
+ (unsigned long long)dataSizeInDir:(NSString *)directory;


/**
 清理目录中的文件

 @param directory 目录名
 */
+ (void)clearDataInDir:(NSString *)directory;

@end
