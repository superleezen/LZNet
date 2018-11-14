//
//  LZDataRequestManager.h
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZBaseDataRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZDataRequestManager : NSObject
{
    NSMutableArray *_requests;
}
+ (LZDataRequestManager *)sharedManager;
- (void)addRequest:(LZBaseDataRequest *)request;
- (void)removeRequest:(LZBaseDataRequest *)request;

@end

NS_ASSUME_NONNULL_END
