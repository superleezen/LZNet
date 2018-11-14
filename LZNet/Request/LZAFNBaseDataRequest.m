//
//  LZAFNBaseDataRequest.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZAFNBaseDataRequest.h"
#import "AFNetworking.h"
#import "LZDataRequestManager.h"

#define outTime 20.f

@interface LZAFNBaseDataRequest ()
{
    NSURLSessionDataTask  *_requestOperation;
}
@property(nonatomic,strong)NSDate *willStartDate;

@end

@implementation LZAFNBaseDataRequest

- (NSString *)contentType{
    NSString *charset = @"utf-8";
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset=%@", charset];
    return contentType;
}

-(CGFloat)timeOut{
    return 15;
}

+ (void)showNetworkActivityIndicator{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)hideNetworkActivityIndicator{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

- (void)networkingOperationDidStart:(NSNotification *)notification{
    [[self class] showNetworkActivityIndicator];
    [self showIndicator:TRUE];
}

/**
 网络请求操作结束
 */
- (void)networkingOperationDidFinish:(NSNotification *)notification{
    [[self class] hideNetworkActivityIndicator];
    [self showIndicator:FALSE];
}

- (void)notifyDelegateDownloadProgress{
    //using block
    if (_onRequestProgressChangedBlock) {
        _onRequestProgressChangedBlock(self, self.downProgress);
    }
}

- (void)notifyDelegateUpdateProgress{
    if (_onRequestProgressUpdateBlock) {
        _onRequestProgressUpdateBlock(self,self.updateProgress);
    }
}

- (void)generateRequestWithUrl:(NSString*)url withParameters:(NSDictionary*)params{
    // process params
    self.willStartDate = [NSDate date];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
    [allParams addEntriesFromDictionary: params];
    NSDictionary *staticParams = [self getStaticParams];
    if (staticParams != nil) {
        [allParams addEntriesFromDictionary:staticParams];
    }
    __weak __block typeof(self) wSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", nil];
    ((AFJSONResponseSerializer*)manager.responseSerializer).removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
    //开始请求
    [self networkingOperationDidStart:nil];
    if (LZRequestMethodGet == [self getRequestMethod]){
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self setHeadWithAFManager:manager];
        _requestOperation = [manager GET:url parameters:allParams progress:^(NSProgress * _Nonnull downloadProgress) {
            wSelf.downProgress = downloadProgress.totalUnitCount/downloadProgress.completedUnitCount;
        }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [wSelf networkingOperationDidFinish:nil];
            [wSelf requestSuccess:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [wSelf networkingOperationDidFinish:nil];
            [wSelf requestFailure:task error:error];
        }];
    }else if(LZRequestMethodPost == [self getRequestMethod]){
        [self requestParameter:manager withURL:url withParameters:allParams];
    }else if(LZRequestMethodGetAndPost == [self getRequestMethod]){
        url = [self connectUrl:self.getInfo url:url];
        [self requestParameter:manager withURL:url withParameters:allParams];
    }else if(LZRequestMethodMultipartPost == [self getRequestMethod]){
        switch (self.parmaterEncoding) {
                //上传
            case LZUploadParameterEncoding:
            {
                [self setHeadWithAFManager:manager];
                allParams[@"fileName"] = @"original";
                _requestOperation = [manager POST:url  parameters:allParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    if (wSelf.upLoadDataType == LZUpLoadData) {
                        [formData appendPartWithFileData:wSelf.updata name:@"data" fileName:@"user_item.jpg" mimeType:@"image/jpeg"];
                    }else if(wSelf.upLoadDataType == LZUpLoadDataPath) {
                        NSData *data = [NSData dataWithContentsOfFile:[wSelf updata]];
                        [formData appendPartWithFileData:data name:@"data" fileName:@"user_item.jpg" mimeType:@""];
                    }
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    wSelf.updateProgress = uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount;
                    if (wSelf.onRequestProgressUpdateBlock) {
                        wSelf.onRequestProgressUpdateBlock(wSelf,wSelf.updateProgress);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [wSelf networkingOperationDidFinish:nil];
                    [wSelf requestSuccess:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [wSelf networkingOperationDidFinish:nil];
                    [wSelf requestFailure:task error:error];
                    
                }];
                
            }
                break;
            case LZDownParameterEncoding:
            {
                //下载
                __weak __block typeof(self) wself = self;
                NSURLSessionDownloadTask *task =  [manager downloadTaskWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]  progress:^(NSProgress * _Nonnull downloadProgress) {
                    wSelf.downProgress = downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount;
                    [wSelf notifyDelegateDownloadProgress];
                } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    // 指定下载文件保存的路径
                    //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
                    // 将下载文件保存在缓存路径中
                    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    NSString *path = [[cacheDir stringByAppendingPathComponent:@"LZNetWorkDown"] stringByAppendingPathComponent:response.suggestedFilename];
                    NSError *error = nil;
                    
                    BOOL isDir = NO;
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    BOOL existed = [fileManager fileExistsAtPath:[path stringByDeletingLastPathComponent] isDirectory:&isDir];
                    if ( !(isDir == YES && existed == YES) ){
                        [fileManager createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
                    }
                    // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
                    NSURL *fileURL = [NSURL fileURLWithPath:path];
                    if (wSelf.downPath) {
                        return [NSURL fileURLWithPath:wSelf.downPath];
                    }
                    return fileURL;
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@ %@", filePath, error);
                        [wself networkingOperationDidFinish:nil];
                        if (error == nil) {
                            [wself networkingOperationDidFinish:nil];
                            wself.isSuccess = YES;
                            if (wself.onRequestFinishBlock) {
                                wself.onRequestFinishBlock(wself);
                            }
                        }else{
                            wself.isSuccess = NO;
                            if (wself.onRequestFailedBlock) {
                                wself.onRequestFailedBlock(wself,error);
                            }
                            [wself networkingOperationDidFinish:nil];
                        }
                        [wSelf requestFailure:nil error:error];
                    });
                }];
                [task resume];
            }
            default:
                [wSelf networkingOperationDidFinish:nil];
                break;
        }
    }
}

-(void)requestParameter:(AFHTTPSessionManager*)manager withURL:(NSString*)url withParameters:(NSDictionary*)allParams{
    __weak typeof(self) wSelf = self;
    switch (self.parmaterEncoding) {
        case LZURLParameterEncoding:{
            manager.requestSerializer=[AFHTTPRequestSerializer serializer];
            manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
            [self setHeadWithAFManager:manager];
            _requestOperation = [manager POST:url parameters:allParams progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestSuccess:operation responseObject:responseObject];
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestFailure:operation error:error];
            }];
        }
            break;
        case LZJSONParameterEncoding:
        {
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
            [self setHeadWithAFManager:manager];
            _requestOperation = [manager POST:url parameters:allParams progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestSuccess:operation responseObject:responseObject];
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestFailure:operation error:error];
            }];
        }
            break;
        case LZPropertyListParameterEncoding:
        {
            manager.requestSerializer=[AFPropertyListRequestSerializer serializer];
            manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
            [self setHeadWithAFManager:manager];
            _requestOperation = [manager POST:url parameters:allParams progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestSuccess:operation responseObject:responseObject];
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [wSelf networkingOperationDidFinish:nil];
                [wSelf requestFailure:operation error:error];
            }];
        }
            break;
        default:
            [wSelf networkingOperationDidFinish:nil];
            break;
    }
}

-(void)requestSuccess:(NSURLSessionDataTask *)operation responseObject:(id)responseObject{
    __weak typeof(self) wSelf = self;
    //    if (![responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
    //        responseObject = [responseObject mj_JSONObject];
    //    }
    [wSelf handleResultDic:responseObject];
    [wSelf doRelease];
    //    });
}

-(void)requestFailure:(NSURLSessionDataTask *)operation error:(NSError*) error{
    [self notifyDelegateRequestDidErrorWithError:error];
    #if DEBUG
        [self showNetError:[NSString stringWithFormat:@"%@类请求失败，本消息仅在开发版可见",[self class]]];
    #else
        [self showNetError:@"网络断开链接"];
    #endif
    [self doRelease];
}

-(void)setHeadWithAFManager:(AFHTTPSessionManager*)manager{
    for (NSString *key in self.headDataDic) {
        [manager.requestSerializer setValue:self.headDataDic[key] forHTTPHeaderField:key];
    }
}

- (void)doRequestWithParams:(NSDictionary*)params{
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
}

-(void)showNetError:(NSString*)error{
    if (NO == self.hiddenNetErrorMsg) {
//        [AWHUD showText:error];
        
    }
}

-(NSDictionary*)head{
    return [self getStaticParams];
}

- (void)cancelRequest{
    [_requestOperation cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
    [self showIndicator:FALSE];
    [self doRelease];
}

- (NSString*)getRequestUrl{
    if (self.getRequestHost.length == 0||self.port.length == 0) {
        return nil;
    }
    NSString *host = self.getRequestHost;
    if ([host hasSuffix:@"/"]) {
        host = [host substringToIndex:host.length-1];
    }
    NSString *port = self.port;
    if ([port hasPrefix:@"/"]) {
        port = [port substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@/%@",host,port];
}

- (LZRequestMethod)getRequestMethod{
    return LZRequestMethodPost;
}

-(LZParameterEncoding)parmaterEncoding{
    return LZJSONParameterEncoding;
}

- (NSString *) connectUrl:(NSDictionary *)params url:(NSString *) urlLink{
    if ([params count] == 0) {
        return urlLink;
    }
    // 初始化参数变量
    NSString *str = @"?";
    // 快速遍历参数数组
    for(NSString* key in params) {
        
        if (key.length == 0 ||  [[NSString stringWithFormat:@"%@",params[key]] length] == 0) {
            continue;
        }
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        id value = params[key];
        if ([value isKindOfClass:[NSString class]]) {
            value = [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        str = [NSString stringWithFormat:@"%@%@",str,value];
        str = [str stringByAppendingString:@"&"];
    }
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        // 返回含参url
        return [urlLink stringByAppendingString:str];
    }
    return nil;
}
@end
