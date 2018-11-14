//
//  LZRequestJsonDataHandler.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZRequestJsonDataHandler.h"

@implementation LZRequestJsonDataHandler

- (id)handleResultString:(NSString *)resultString error:(NSError **)error{
    //    NSMutableDictionary *returnDic;
    //    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    if (![resultString isStartWithString:@"{"]) {
    //        resultString = [NSString stringWithFormat:@"{\"data\":%@}", resultString];
    //    }
    //    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
    //    if(resultDic) {
    //        returnDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
    //    }
    //     ;
    //    id dic = [NSDictionary dictionaryWithJSONString:resultString error:error];
    id dic = [NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:error];
    
    return dic;
}

@end
