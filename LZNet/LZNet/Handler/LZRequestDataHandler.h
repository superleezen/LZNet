//
//  LZRequestDataHandler.h
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZRequestDataHandler : NSObject

- (id)handleResultString:(NSString *)resultString error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
