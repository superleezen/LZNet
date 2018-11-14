//
//  LZAFNBaseDataRequest.h
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZBaseDataRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 所有请求继承于此类
 */
@interface LZAFNBaseDataRequest : LZBaseDataRequest

///接口名
@property(nonatomic,strong)NSString *port;

/**
 是否隐藏网络错误的提示
 */
@property(nonatomic,assign)BOOL hiddenNetErrorMsg;
/**
 *  重写后错误信息
 *
 *  @param error 错误信息
 */
-(void)showNetError:(NSString*)error;

@end

NS_ASSUME_NONNULL_END
