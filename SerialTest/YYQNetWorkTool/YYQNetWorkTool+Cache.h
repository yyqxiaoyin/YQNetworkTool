//
//  YYQNetWorkTool+Cache.h
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YYQNetWorkTool.h"

@interface YYQNetWorkTool (Cache)

+ (void)cacheResponseObject:(id)responseObject requestUrl:(NSString *)requestUrl params:(NSDictionary *)params;

+ (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params;

@end
