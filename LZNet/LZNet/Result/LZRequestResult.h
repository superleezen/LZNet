//
//  LZRequestResult.h
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZRequestResult : NSObject

@property (nonatomic,strong) NSNumber *code;
@property(nonatomic,assign)BOOL isNULLData;
@property (nonatomic,strong) NSString *message;
@property(nonatomic,strong)id data;
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,strong)NSNumber *total;
- (instancetype)initWithJsonDic:(NSDictionary*)jsonDic;
- (BOOL)isSuccess;

@end

NS_ASSUME_NONNULL_END
