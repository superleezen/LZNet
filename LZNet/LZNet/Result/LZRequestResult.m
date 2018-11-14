//
//  LZRequestResult.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZRequestResult.h"

@implementation LZRequestResult

- (instancetype)initWithJsonDic:(NSDictionary*)jsonDic{
    self = [super init];
    if (self) {
        if (jsonDic[@"success"]) {
            _code = @([jsonDic[@"success"] integerValue]);
        }
        _message = jsonDic[@"msg"];
        _data = jsonDic[@"data"];
        _message = jsonDic[@"msg"];
    }
    return self;
}

-(BOOL)isSuccess{
    return (_code && [_code intValue] == 0);
}

-(BOOL)isNULLData{
    if([[self.data allValues] count]!=1)
    {
        return NO;
    };
    if (_code && [[self.data allValues][0] isKindOfClass:[NSArray class]] && [[self.data allValues][0] count]==0) {
        return YES;
    }
    return NO;
}

@end
