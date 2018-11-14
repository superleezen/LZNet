//
//  LZDataRequestManager.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZDataRequestManager.h"

@implementation LZDataRequestManager

+ (instancetype)sharedManager {
    static  LZDataRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if(self){
        [self restore];
    }
    return self;
}

#pragma mark - private methods
- (void)restore{
    _requests = [[NSMutableArray alloc] init];
}

#pragma mark - public methods
- (void)addRequest:(ZJBaseDataRequest*)request{
    [_requests addObject:request];
}

- (void)removeRequest:(ZJBaseDataRequest*)request{
    [_requests removeObject:request];
}


@end
