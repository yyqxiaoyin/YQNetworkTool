//
//  YYQNetWorkTool.m
//  SerialTest
//
//  Created by Mopon on 2017/10/24.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YYQNetWorkTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YYQNetWorkTool+Cache.h"

static NSMutableArray   *requestTasks;

static NSTimeInterval   requestTimeout = 20.f;

@implementation YYQNetWorkTool

#pragma mark - manager
+ (AFHTTPSessionManager *)manager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    return manager;
}

+ (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) requestTasks = [NSMutableArray array];
    });
    return requestTasks;
}

#pragma mark - get请求

+ (YQURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                    successBlock:(YQResponseSuccessBlock)successBlock
                       failBlock:(YQResponseFailBlock)failBlock{
    
    YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    session = [manager GET:url
                parameters:params
                  progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       
        
                       if (successBlock) successBlock(responseObject);
                       
                       [[self allTasks] removeObject:session];
                       
    } 
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                       if (failBlock) failBlock(error);
                       [[self allTasks] removeObject:session];
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

+ (YQURLSessionTask *)getAndCacheUrl:(NSString *)url params:(NSDictionary *)params successBlock:(YQResponseSuccessBlock)successBlock failBlock:(YQResponseFailBlock)failBlock{
    
    YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    id responseObj = [self getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj) {
        if (successBlock) successBlock(responseObj);
    }
    
    session = [manager GET:url
                parameters:params
                  progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (successBlock) successBlock(responseObject);
                       [self cacheResponseObject:responseObject requestUrl:url params:params];
                       
                       [[self allTasks] removeObject:session];
                   }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if (failBlock) failBlock(error);
                       [[self allTasks] removeObject:session];
                       
                   }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark - POST
+ (YQURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                     successBlock:(YQResponseSuccessBlock)successBlock
                        failBlock:(YQResponseFailBlock)failBlock{
    YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    session = [manager POST:url
                 parameters:params
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        if (successBlock) successBlock(responseObject);
                        
                        [[self allTasks] removeObject:session];
                        
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        if (failBlock) failBlock(error);
                        
                        [[self allTasks] removeObject:session];
                    }];
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}


+ (void)getWithRequestArray:(NSArray<YQNetWorkRequest *> *)requestArray completeHandle:(YQChainRequestCompleteHandle)completeHandle{
    
    YQPromiseManager *manager = [YQPromiseManager manager];
    
    __block NSInteger errorStartIndex = -1;
    
    [requestArray enumerateObjectsUsingBlock:^(YQNetWorkRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YQPromise *promise = [YQPromise promiseWithHandle:^(dispatch_block_t then) {
            
            [self getWithUrl:obj.url params:obj.params successBlock:^(id responese) {
                
                obj.response = responese;
                
                then();
                
            } failBlock:^(NSError *error) {
                
                obj.error = error;
                
                [self cancleAllRequest];
                
                if (error.code != -999) {
                    errorStartIndex = idx;
                }
                
                if (error.code == -999 && idx == 0) {
                    errorStartIndex = 0;
                }
                
                then();
            }];
        }];
        
        [manager addPromise:promise];
        
    }];
    
    [manager completeWithHandle:^{
        
        NSLog(@"全部请求完成");
        completeHandle(requestArray,errorStartIndex);
        
    }];

}

+ (void)postWithRequestArray:(NSArray<YQNetWorkRequest *> *)requestArray completeHandle:(YQChainRequestCompleteHandle)completeHandle{
    YQPromiseManager *manager = [YQPromiseManager manager];
    
    __block NSInteger errorStartIndex = -1;
    
    [requestArray enumerateObjectsUsingBlock:^(YQNetWorkRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YQPromise *promise = [YQPromise promiseWithHandle:^(dispatch_block_t then) {
            
            [self postWithUrl:obj.url params:obj.params successBlock:^(id responese) {
                
                obj.response = responese;
                
                then();
                
            } failBlock:^(NSError *error) {
                obj.error = error;
                
                [self cancleAllRequest];
                
                if (error.code != -999) {
                    errorStartIndex = idx;
                }
                
                if (error.code == -999 && idx == 0) {
                    errorStartIndex = 0;
                }
                
                then();
            }];
        }];
        
        [manager addPromise:promise];
        
    }];
    
    [manager completeWithHandle:^{
        
        NSLog(@"全部请求完成");
        completeHandle(requestArray,errorStartIndex);
        
    }];
}

#pragma mark - other method
+ (void)cancleAllRequest{
    @synchronized (self){
        [[self allTasks] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url{
    if (!url) return;
    @synchronized (self){
        [[self allTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

@end
