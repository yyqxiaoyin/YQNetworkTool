//
//  ViewController.m
//  SerialTest
//
//  Created by Mopon on 2017/10/20.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "ViewController.h"
#import "YQPromise.h"
#import <AFNetworking.h>
#import "YYQNetWorkTool.h"

const NSString * key = @"65e62c14265ffc66985dd44ad3a36933";

#define API @"http://www.kuaidi100.com/query?type=shentong&postid=402693796694"

@interface ViewController ()

@end

@implementation ViewController

- (void)request{
    
//    NSMutableArray *requests = [NSMutableArray array];
//    for (int i =0; i<4; i++) {
//        YQNetWorkRequest *request = [[YQNetWorkRequest alloc]init];
//        request.url = API;
//        request.params = @{};
//        [requests addObject:request];
//    }
//
//    [YYQNetWorkTool getWithArray:requests successBlock:^(NSArray<id> *responeses) {
//
//        NSLog(@"%ld",responeses.count);
//
//    } failBlock:^(NSArray<NSError *> *errors) {
//
//        NSLog(@"%ld",errors.count);
//    }];
    NSMutableArray *requests = [NSMutableArray array];
    YQNetWorkRequest *request1 = [[YQNetWorkRequest alloc]init];
    request1.url = @"htt:/www.kuaidi100.com/query?type=shentong&postid=402693796694";
    request1.params = @{};
    [requests addObject:request1];
    
    YQNetWorkRequest *request2 = [[YQNetWorkRequest alloc]init];
    request2.url = API;
    request2.params = @{};
    [requests addObject:request2];
    
    YQNetWorkRequest *request3 = [[YQNetWorkRequest alloc]init];
    request3.url = API;
    request3.params = @{};
    [requests addObject:request3];
    
    YQNetWorkRequest *request4 = [[YQNetWorkRequest alloc]init];
    request4.url = API;
    request4.params = @{};
    [requests addObject:request4];
    
    [YYQNetWorkTool getWithRequestArray:@[request1,request2,request3,request4] completeHandle:^(NSArray<YQNetWorkRequest *> *requestArray, NSInteger errorStartIndex) {
        
        NSLog(@"%@",requestArray);
        
        NSLog(@"%ld",errorStartIndex);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self request];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
