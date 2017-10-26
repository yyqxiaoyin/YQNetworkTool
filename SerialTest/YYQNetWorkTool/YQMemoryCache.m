//
//  YQMemoryCache.m
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YQMemoryCache.h"

static NSCache *shareCache;

@implementation YQMemoryCache

+ (NSCache *)shareCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareCache == nil) shareCache = [[NSCache alloc]init];
    });
    
    return shareCache;
}

+ (void)writeData:(id)data forKey:(NSString *)key{
    
    assert(data);
    
    assert(key);
    
    NSCache *cache = [YQMemoryCache shareCache];
    
    [cache setObject:data forKey:key];
}

+ (id)readDataWithKey:(NSString *)key{
    
    assert(key);
    
    id data = nil;
    
    NSCache *cache = [YQMemoryCache shareCache];
    
    data = [cache objectForKey:key];
    
    return data;
}

@end
