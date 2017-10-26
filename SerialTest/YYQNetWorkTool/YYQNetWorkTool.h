//
//  YYQNetWorkTool.h
//  SerialTest
//
//  Created by Mopon on 2017/10/24.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQPromise.h"
#import "YQNetWorkRequest.h"

typedef NS_ENUM(NSUInteger, YQNetworkStatus) {
    /**
       未知网络
     */
    YQNetworkStatusUnknown              = 1 << 0,
    /**
       无法连接
     */
    YQNetworkStatusNotReachable         = 1 << 1,
    /**
       WWAN网络
     */
    YQNetworkStatusReachableViaWWAN     = 1 << 2,
    /**
       WiFi网络
     */
    YQNetworkStatusReachableViaWiFi     = 1 << 3,
};

/**
   请求任务
 */
typedef NSURLSessionTask YQURLSessionTask;


/**
 成功回调

 @param responese 成功后返回的数据
 */
typedef void(^YQResponseSuccessBlock)(id responese);


/**
 失败回调

 @param error 失败后返回的错误信息
 */
typedef void(^YQResponseFailBlock)(NSError *error);


/**
 多请求成功回调

 @param responeses 成功后返回的数据数组,顺序与请求数组顺序一致
 */
typedef void(^YQChainRequestResponseSuccessBlock)(NSArray <id>*responeses);


/**
 多请求完成回调

 @param requestArray 请求数组
 @param errorStartIndex 错误开始的下标  如果所有请求全部成功  值为 -1
 */
typedef void(^YQChainRequestCompleteHandle)(NSArray <YQNetWorkRequest *> *requestArray ,NSInteger errorStartIndex);


/**
 多请求失败回调

 @param errors 失败后返回的错误信息数组,顺序与请求数组顺序一致
 */
typedef void(^YQChainRequestResponseFailBlock)(NSArray <NSError *>*errors);


@interface YYQNetWorkTool : NSObject

+ (void)cancleAllRequest;

+ (void)cancelRequestWithURL:(NSString *)url;


/**
 Get请求

 @param url             请求路径
 @param params          请求参数
 @param successBlock    成功回调
 @param failBlock       失败回调
 @return                返回请求任务对象 可用来取消请求
 */
+ (YQURLSessionTask *)getWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                        successBlock:(YQResponseSuccessBlock)successBlock
                           failBlock:(YQResponseFailBlock)failBlock;

/**
 Get请求(带缓存)
 
 @param url             请求路径
 @param params          请求参数
 @param successBlock    成功回调
 @param failBlock       失败回调
 @return                返回请求任务对象 可用来取消请求
 */
+ (YQURLSessionTask *)getAndCacheUrl:(NSString *)url
                          params:(NSDictionary *)params
                    successBlock:(YQResponseSuccessBlock)successBlock
                       failBlock:(YQResponseFailBlock)failBlock;



/**
 POST请求
 
 @param url             请求路径
 @param params          请求参数
 @param successBlock    成功回调
 @param failBlock       失败回调
 @return                返回请求任务对象 可用来取消请求
 */
+ (YQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                     successBlock:(YQResponseSuccessBlock)successBlock
                        failBlock:(YQResponseFailBlock)failBlock;


/**
 Get方式发起一组链式请求(有其中的一个请求请求失败,则后续请求取消)

 @param requestArray    请求的数组
 @param completeHandle  完成回调  返回YQNetWorkRequest 对象的数组 可通过属性获取对应请求的请求结果或者错误信息
 */
+ (void)getWithRequestArray:(NSArray <YQNetWorkRequest *> *)requestArray
             completeHandle:(YQChainRequestCompleteHandle)completeHandle;

/**
 Post方式发起一组链式请求(有其中的一个请求请求失败,则后续请求取消)
 
 @param requestArray    请求的数组
 @param completeHandle  完成回调  返回YQNetWorkRequest 对象的数组 可通过属性获取对应请求的请求结果或者错误信息
 */
+ (void)postWithRequestArray:(NSArray <YQNetWorkRequest *> *)requestArray
              completeHandle:(YQChainRequestCompleteHandle)completeHandle;

@end
