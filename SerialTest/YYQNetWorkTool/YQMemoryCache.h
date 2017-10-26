//
//  YQMemoryCache.h
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQMemoryCache : NSObject

/**
 将数据写入内存

 @param data 数据
 @param key 键值
 */
+ (void)writeData:(id)data forKey:(NSString *)key;


/**
 从内存中读取数据

 @param key 键值
 */
+ (id)readDataWithKey:(NSString *)key;

@end
