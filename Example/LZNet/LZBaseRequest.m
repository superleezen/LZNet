//
//  LZBaseRequest.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/14.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZBaseRequest.h"
#import "LZBaseRequestResult.h"

@implementation LZBaseRequest

///直接定义请求接口  和 getRequestHost 二选一
//- (NSString *)getRequestUrl{
//    return @"htttp://www.baidu.com/logistics/apps/processingplan/rawmaterials.php";
//}

///配合portd定义接口
- (NSString *)getRequestHost {
    return @"https://gplo86fq.api.lncld.net";
}
///拼接在getRequestHost后面组成一个完成的URL
-(NSString*)port{
    return @"/1.1/classes/Express";
}

////存放head信息
- (NSDictionary*)headDataDic{
    NSMutableDictionary *supHeadDic = [super headDataDic].mutableCopy;

    
    return supHeadDic;
}

////定义请求方式post
- (LZRequestMethod)getRequestMethod{
    return LZRequestMethodGet;
}

///
-(LZParameterEncoding)parmaterEncoding{
    return LZJSONParameterEncoding;
}

///params里传输的固定参数
- (NSDictionary*)getStaticParams{
    NSMutableDictionary *body = [super getStaticParams].mutableCopy;
    return body;
}

-(NSDictionary*)getGetInfoStaticParams{
    NSMutableDictionary *getInfo = [super getGetInfoStaticParams].mutableCopy;
    
    return getInfo;
}

///重写返回方式
- (void)processResult{
    NSDictionary *resultDic = (self.handleredResult);
    self.result = [[LZBaseRequestResult alloc] initWithJsonDic:resultDic];
}

@end
