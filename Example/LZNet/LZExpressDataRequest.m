//
//  LZExpressDataRequest.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/14.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZExpressDataRequest.h"

@implementation LZExpressDataRequest

///拼接在getRequestHost后面组成一个完成的URL
-(NSString*)port{
    return @"/1.1/classes/Express";
}

-(NSDictionary*)headDataDic{
    NSMutableDictionary *headDic = [super headDataDic].mutableCopy;
    headDic[@"x-lc-id"] = @"GPlO86Fq8DiLVY7SSoscjc3z";
    headDic[@"x-lc-prod"] = @"1";
    headDic[@"x-lc-sign"] = @"a611287ad253198b4951f66d7e249945,1540050277552";
    
    return headDic;
}

@end
