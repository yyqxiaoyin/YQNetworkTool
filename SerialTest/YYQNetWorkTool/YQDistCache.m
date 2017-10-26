//
//  YQDistCache.m
//  SerialTest
//
//  Created by Mopon on 2017/10/25.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "YQDistCache.h"

@implementation YQDistCache

+ (void)writeData:(id)data
            toDir:(NSString *)directory
         fileName:(NSString *)fileName{
    assert(data);
    assert(directory);
    assert(fileName);
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (error) {
        NSLog(@"create Directory error is %@",error.localizedDescription);
        return;
    }
    
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}

+ (id)readDataFromDir:(NSString *)directory fileName:(NSString *)fileName{
    
    assert(directory);
    
    assert(fileName);
    
    NSData *data = nil;
    
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    
    data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    return data;
}

+ (unsigned long long)dataSizeInDir:(NSString *)directory {
    
    if (!directory) {
        return 0;
    }
    
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
            if (!error) {
                for (NSString *subFile in array) {
                    NSString *filePath = [directory stringByAppendingPathComponent:subFile];
                    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
                    
                    if (!error) {
                        total += [attributes[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (void)clearDataInDir:(NSString *)directory {
    if (directory) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:directory error:&error];
            if (error) {
                NSLog(@"清理缓存是出现错误：%@",error.localizedDescription);
            }
        }
    }
}


@end
