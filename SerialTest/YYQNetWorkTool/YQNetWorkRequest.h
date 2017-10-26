//
//  YQNetWorkRequest.h
//  SerialTest
//
//  Created by Mopon on 2017/10/26.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQNetWorkRequest : NSObject

/** 请求的url */
@property (nonatomic ,strong) NSString *url;

/** 请求拼接的参数 */
@property (nonatomic ,strong) NSDictionary *params;

/** 请求结果 */
@property (nonatomic ,strong) id response;

/** 错误 */
@property (nonatomic ,strong) NSError *error;

@end
