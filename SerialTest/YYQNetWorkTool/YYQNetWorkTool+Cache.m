//
//  YYQNetWorkTool+Cache.m
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YYQNetWorkTool+Cache.h"
#import <CommonCrypto/CommonDigest.h>
#import "YQMemoryCache.h"
#import "YQDistCache.h"

static NSString *const cacheDirKey = @"cacheDirKey";

#define YQ_NSUSERDEFAULT_GETTER(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define YQ_NSUSERDEFAULT_SETTER(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]

@implementation YYQNetWorkTool (Cache)

+ (void)cacheResponseObject:(id)responseObject
                 requestUrl:(NSString *)requestUrl
                     params:(NSDictionary *)params{
    
    assert(responseObject);
    
    assert(requestUrl);
    
    if (!params) params = @{};
    
    NSString *originString = [NSString stringWithFormat:@"%@+%@",requestUrl,params];
    
    NSString *hash = [self md5:originString];
    
    NSData *data = nil;
    
    NSError *error = nil;
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        data =responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (error == nil) {
        //缓存到内存中
        [YQMemoryCache writeData:responseObject forKey:hash];
        
        
        //缓存到磁盘中
        //磁盘路径
        NSString *directoryPath = nil;
        directoryPath = YQ_NSUSERDEFAULT_GETTER(cacheDirKey);
        if (!directoryPath) {
            directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"YQNetworking"] stringByAppendingPathComponent:@"networkCache"];
            
            YQ_NSUSERDEFAULT_SETTER(directoryPath,cacheDirKey);
        }
        [YQDistCache writeData:data toDir:directoryPath fileName:hash];
    }
    
    
}

+ (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params{
    
    assert(requestUrl);
    
    id cacheData = nil;
    
    if (!params) params = @{};
    
    NSString *originString = [NSString stringWithFormat:@"%@+%@",requestUrl,params];
    
    NSString *hash = [self md5:originString];
    
    //先从内存中查找
    cacheData = [YQMemoryCache readDataWithKey:hash];
    
    if (!cacheData) {
        NSString *directoryPath = YQ_NSUSERDEFAULT_GETTER(cacheDirKey);
        
        if (directoryPath) cacheData = [YQDistCache readDataFromDir:directoryPath fileName:hash];
    }
    
    return cacheData;
}

+ (NSString *)md5:(NSString *)string{
    
    if (string ==nil || string.length == 0) {
        return nil;
    }
    
    const char *data = string.UTF8String;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)strlen(data), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;

}

@end
