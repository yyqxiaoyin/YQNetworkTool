//
//  YQPromise.h
//  SerialTest
//
//  Created by Mopon on 2017/10/20.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YQPromise;

typedef void(^YQPromiseHandle)(dispatch_block_t then);

@interface YQPromise : NSObject

@property (nonatomic ,copy) YQPromiseHandle handle;

- (instancetype)initWithHandle:(YQPromiseHandle)handle;

+ (instancetype)promise;

+ (instancetype)promiseWithHandle:(YQPromiseHandle)handle;

@property (nonatomic, assign) int a;

@end

@interface YQPromiseManager : NSObject

- (instancetype)initWithPromise:(YQPromise *)promise;

- (instancetype)initWithPromises:(NSArray <YQPromise *> *)promises;

+ (instancetype)manager;

+ (instancetype)managerWithPromise:(YQPromise *) promise;

+ (instancetype)managerWithPromises:(NSArray <YQPromise *> *)promises;

- (void)addPromise:(YQPromise *)promise;

- (void)completeWithHandle:(void(^)(void))completeHandle;

@end
