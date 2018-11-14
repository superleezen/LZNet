//
//  LZBaseRequestResult.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/14.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZBaseRequestResult.h"

@implementation LZBaseRequestResult

- (instancetype)initWithJsonDic:(NSDictionary*)jsonDic{
    if (self = [super init]) {
        if(jsonDic[@"results"]){
            self.code = @(1);
        }else{
            self.code = @(0);
        }
        self.message = jsonDic[@"msg"];
        self.data = jsonDic[@"results"];
        self.total = @([(NSArray *)self.data count]);
    }
    return self;
}
///自定义重写success
-(BOOL)isSuccess{
    if ([self.code isEqualToNumber:@(0)]) {
        return NO;
    }else{
        return YES;
    }
}
@end
