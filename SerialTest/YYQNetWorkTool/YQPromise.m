//
//  YQPromise.m
//  SerialTest
//
//  Created by Mopon on 2017/10/20.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YQPromise.h"

@implementation YQPromise

- (instancetype)initWithHandle:(YQPromiseHandle)handle{
    if (self = [super init]) {
        _handle = [handle copy];
    }
    return self;
}

+ (instancetype)promise{
    return [[self alloc] initWithHandle:nil];
}

+ (instancetype)promiseWithHandle:(YQPromiseHandle)handle{
    id instance = [[YQPromise alloc] initWithHandle:handle];
    return instance;
}

- (void)dealloc{
//    NSLog(@"%@  dealloc",self);
//    NSLog(@"%p",self);
}

@end

static NSInteger const YQPromiseIndexUnkown = -1;

@interface YQPromiseManager ()
{
    NSMutableArray <YQPromise *> *container;
    NSInteger currentIndex;
}

@property (getter=isWorking) BOOL working;

@property (nonatomic, copy) void(^completeHandle)(void);

@end

@implementation YQPromiseManager

- (void)addPromise:(YQPromise *)promise{
    
    @synchronized (self){
        [container addObject:promise];
    }
    [self handleNextPromiseAfterIndex:currentIndex];
}

- (void)handleNextPromiseAfterIndex:(NSInteger)index{
    
    if (self.isWorking) return;
    
    NSUInteger count = container.count;
    if (!count) return;
    
    NSInteger nextIndex = YQPromiseIndexUnkown;
    
    YQPromise *nextPromise = nil;
    
    if (index == YQPromiseIndexUnkown) {
        nextPromise = container.firstObject;
        nextIndex = 0;
    }else{
        nextIndex = index + 1;
        if (nextIndex < count) {
            nextPromise = container[nextIndex];
        }else{
            if (self.completeHandle) {
                self.completeHandle();
            }
        }
    }
    
    if (!nextPromise) return;
    
    self.working = YES;
    
    currentIndex = nextIndex;
    
    if (nextPromise.handle) {
        nextPromise.handle(^{
            self.working = NO;
            [self handleNextPromiseAfterIndex:nextIndex];
        });
    }
    
}

- (void)completeWithHandle:(void (^)(void))completeHandle{
    self.completeHandle = [completeHandle copy];
}

- (instancetype)initWithPromises:(NSArray<YQPromise *> *)promises{
    self = [super init];
    if (self) {
        container = [[NSMutableArray alloc] init];
        [container addObjectsFromArray:promises ? : @[]];
        
        currentIndex = YQPromiseIndexUnkown;
        
        [self handleNextPromiseAfterIndex:currentIndex];
    }
    return self;
}

- (instancetype)initWithPromise:(YQPromise *)promise{
    return [self initWithPromises:promise ? @[promise] : @[]];
}

- (instancetype)init{
    return [self initWithPromises:@[]];
}

+ (instancetype)manager{
    return [[self alloc] init];
}

+ (instancetype)managerWithPromise:(YQPromise *)promise{
    return [[self alloc] initWithPromise:promise];
}

+ (instancetype)managerWithPromises:(NSArray<YQPromise *> *)promises{
    return [[self alloc] initWithPromises:promises];
}

- (void)dealloc{
    NSLog(@"manager dealloc");
}

@end
