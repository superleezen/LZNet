//
//  LZBaseDataRequest.m
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import "LZBaseDataRequest.h"
#import "AFNetworking.h"
#import "LZDataRequestManager.h"
#import "LZRequestJsonDataHandler.h"
#import "LZNetHUD.h"

#define DEFAULT_LOADING_MESSAGE  @"正在加载..."
#define outTime 20.f

@interface LZBaseDataRequest ()
{
    UIView *_indicatorView;
}

@property (nonatomic, strong) NSString *loadingMessage;

@end

@implementation LZBaseDataRequest

+(NSString*)toString{
    return NSStringFromClass([self class]);
}
#pragma mark - init methods using delegate

-(void)beginRequest{
    [[LZDataRequestManager sharedManager] addRequest:self];
    [self doRequestWithParams:_userinfo];

}


#pragma mark - init commentWithBlock
+(id)requestCommentWithParameters:(NSDictionary*)params onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    
    LZBaseDataRequest *request = [[[self class] alloc] requestCommentWithParameters:params onRequestFinished:onFinishedBlock onRequestFailed:onFailedBlock];
    [request beginRequest];
    return request;
}

-(id)requestCommentWithParameters:(NSDictionary*)params onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:NSStringFromClass([self class])
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    return request;
}

+(id)requestCommentWithParameters:(NSDictionary*)params withIndicatorView:(UIView*)IndicatorView onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] requestCommentWithParameters:params withIndicatorView:IndicatorView onRequestFinished:onFinishedBlock onRequestFailed:onFailedBlock];
    [request beginRequest];
    return request;
}

-(id)requestCommentWithParameters:(NSDictionary*)params withIndicatorView:(UIView*)IndicatorView onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:IndicatorView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:NSStringFromClass([self class])
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    return request;
}

+ (id)requestCommentWithParameters:(NSDictionary*)params
                 withIndicatorView:(UIView*)indiView
                 onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] requestCommentWithParameters:params withIndicatorView:indiView onRequestFinished:onFinishedBlock];
    [request beginRequest];
    return request;
}

- (id)requestCommentWithParameters:(NSDictionary*)params
                 withIndicatorView:(UIView*)indiView
                 onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:NSStringFromClass([self class])
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    
    return request;
}

+ (id)requestCommentWithGetParameters:(NSDictionary<NSString *,NSString*>*)getParams postParameters:(NSDictionary*)postParams
                    withIndicatorView:(UIView*)indiView
                    onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:postParams
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request.getInfo addEntriesFromDictionary:getParams];
    [request.getInfo addEntriesFromDictionary:[request getGetInfoStaticParams]];
    //    request.getInfo = [self dictionaryWithDictionary:getParams];
    [request beginRequest];
    return request;
}

+ (id)requestCommentWithGetParameters:(NSDictionary<NSString *,NSString*>*)getParams postParameters:(NSDictionary*)postParams
                    onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:postParams
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request.getInfo addEntriesFromDictionary:getParams];
    [request.getInfo addEntriesFromDictionary:[request getGetInfoStaticParams]];
    [request beginRequest];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    
    [request beginRequest];
    return request;
    
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

+ (id)requestWithSuffixParam:(NSString*)suffixParam
                  parameters:(NSDictionary*)params
           withIndicatorView:(UIView*)indiView
           withCancelSubject:(NSString*)cancelSubject
           onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
             onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:suffixParam
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [request beginRequest];
    return request;
}

//上传
+(id)requestWithUpLoadDataPath:(NSString*)dataPath
                    parameters:(NSDictionary*)params
             withCancelSubject:(NSString*)cancelSubject
                onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
             onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
             onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
               onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
       onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:dataPath
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    request.onRequestProgressUpdateBlock = [onRequestProgress copy];
    request.upLoadDataType = LZUpLoadDataPath;
    request.updata = dataPath;
    [request beginRequest];
    return request;
}


+(id)requestWithUpLoadData:(NSData*)data
                parameters:(NSDictionary*)params
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:data
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    request.onRequestProgressUpdateBlock = [onRequestProgress copy];
    [request beginRequest];
    return request;
}

+(id)requestWithUpLoadData:(NSData*)data
                parameters:(NSDictionary*)params
                    suffix:(NSString*)suffix
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:data
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    request.onRequestProgressUpdateBlock = [onRequestProgress copy];
    request.fileSuffix = suffix;
    [request beginRequest];
    return request;
}

//下载
+(id)requestDownUrlString:(NSString*)url
               parameters:(NSDictionary*)params
                 downPath:(NSString*)downPath
            cancelSubject:(NSString*)cancelSubject
           onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
        onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
        onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
          onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
 onRequestProgressChanged:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress{
    LZBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:downPath
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    
    request.onRequestProgressChangedBlock = [onRequestProgress copy];
    [request beginRequest];
    return request;
}

- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
             suffixParam:(NSString*)suffixParam
       withIndicatorView:(UIView*)indiView
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withFilePath:(NSString*)localFilePath
                withData:(id)data
                downPath:(NSString*)downPath
          onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(LZBaseDataRequest *request,float))onProgressChangedBlock{
    self = [super init];
    if(self) {
        if ([data isKindOfClass:[NSString class]]) {
            self.upLoadDataType = LZUpLoadDataPath;
        }else
        {
            self.upLoadDataType = LZUpLoadData;
        }
        _downPath = downPath;
        _updata = data;
        _parmaterEncoding = LZURLParameterEncoding;
        _isLoading = NO;
        _handleredResult = nil;
        _result = nil;
        
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
        if (suffixParam) {
            _requestUrl = [_requestUrl stringByAppendingFormat:@"/%@",suffixParam];
        }
        _indicatorView = indiView;
        _useSilentAlert = silent;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        _requestStartDate = [NSDate date];
        _userinfo = [[NSDictionary alloc] initWithDictionary:params];

    }
    return self;
}

#pragma mark - file download related init methods

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
          onProgressChanged:(void(^)(LZBaseDataRequest *request,float))onProgressChangedBlock{
    
    LZBaseDataRequest *request = [[[self class] alloc]initWithParameters:params
                                                          withRequestUrl:nil
                                                             suffixParam:nil
                                                       withIndicatorView:indiView
                                                      withLoadingMessage:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:YES
                                                            withFilePath:localFilePath
                                                                withData:nil
                                                                downPath:nil
                                                          onRequestStart:nil
                                                       onRequestFinished:onFinishedBlock
                                                       onRequestCanceled:nil
                                                         onRequestFailed:nil
                                                       onProgressChanged:onProgressChangedBlock];
    [request beginRequest];
    return request;
}

#pragma mark - lifecycle methods

- (void)doRelease{
    //remove self from Request Manager to release self;
    [[LZDataRequestManager sharedManager] removeRequest:self];
}

- (void)dealloc{
    //DDLogDebug(@"request %@ is released, time spend on this request:%f seconds", [self class],[[NSDate date] timeIntervalSinceDate:_requestStartDate]);
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse{
    NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (void)generateRequestHandler{
    _requestDataHandler = [[LZRequestJsonDataHandler alloc] init];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    [self notifyDelegateRequestDidSuccess];
    return NO;
}

//可以子类重写
- (void)processResult{
    NSDictionary *resultDic = (self.handleredResult);
    _result = [[LZRequestResult alloc] initWithJsonDic:resultDic];
    if (![_result isSuccess]) {
        //DDLogDebug(@"request[%@] failed with message %@",self,_result.code);
    }else {
        //DDLogDebug(@"request[%@] :%@" ,self ,@"success");
    }
}

- (BOOL)processDownloadFile{
    return FALSE;
}

- (NSString*)encodeURL:(NSString *)string{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

- (void)cancelRequest{
    
}

- (void)showNetowrkUnavailableAlertView:(NSString*)message{
    if (message && [message length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showIndicator:(BOOL)bshow{
    _isLoading = bshow;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUD:bshow];
    });
}

- (void)showHUD:(BOOL)bshow{
    if (bshow) {
        if (_indicatorView) {
            [self showHUDInView:_indicatorView];
        }
    }else{
        if (_indicatorView) {
            [self hideHUDToView:_indicatorView];
            _indicatorView = nil;
        }
    }
}

///重写
- (void)showHUDInView:(UIView *)indicatorView{
    [LZNetHUD showHUDAddedTo:indicatorView];
}

///重写
- (void)hideHUDToView:(UIView *)indicatorView{
     [LZNetHUD hideHudTo:indicatorView];
}

- (void)notifyDelegateRequestDidSuccess{
    [self showIndicator:NO];
    if (_onRequestFinishBlock) {
        _onRequestFinishBlock(self);
    }
}

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error{
    //using block callback
    [self showIndicator:NO];
    self.error = error;
    if (_onRequestFailedBlock) {
        _onRequestFailedBlock(self, error);
    }
}

- (BOOL)isDownloadFileRequest{
    return _filePath && [_filePath length];
}

- (BOOL)handleResultDic:(NSMutableDictionary*)resultDic{
    BOOL success = FALSE;
    NSError *error = nil;
    if([self isDownloadFileRequest]) {
        success = [self processDownloadFile];
    }else {
        self.rawResultString = [resultDic description];
        //add callback here
        if (![resultDic description] || ![[resultDic description] length]) {
            //DDLogDebug(@"!empty response error with request:%@", [self class]);
            [self notifyDelegateRequestDidErrorWithError:nil];
            return NO;
        }
        [self generateRequestHandler];
        self.handleredResult = resultDic;
        if(self.handleredResult) {
            success = TRUE;
            [self processResult];
        }
        else {
            success = FALSE;
        }
    }
    if (success) {
        [self notifyDelegateRequestDidSuccess];
    }else {
        //DDLogDebug(@"parse error %@", error);
        [self notifyDelegateRequestDidErrorWithError:error];
    }
    return success;
}

- (BOOL)isSuccess{
    if (self.result) {
        return self.result.isSuccess;
    }else{
        return _isSuccess;
    }
}

- (BOOL)isNULLData{
    if (self.result) {
        return self.result.isNULLData;
    }else{
        return _isNULLData;
    }
}

#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params{
    NSAssert([@"LZBaseDataRequest" isEqualToString:NSStringFromClass([self class])], @"subclass should override the method!");
}

- (NSStringEncoding)getResponseEncoding{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (LZRequestMethod)getRequestMethod{
    return LZRequestMethodGet;
}

- (NSString*)getRequestUrl{
    if (!_requestUrl||![_requestUrl length]) {
         NSAssert([@"LZBaseDataRequest" isEqualToString:NSStringFromClass([self class])], @"subclass should override the method!");
    }
    return @"";
}

- (NSString*)downPath{
    if (!_downPath) {
        
        return [self dataFilePath];
    }
    return _downPath;
}

//创建默认路径
- (NSString *)dataFilePath {
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *myfileGroup = [myDocPath stringByAppendingString:@"/LZAFNet"];
    [self createFolder:myfileGroup];
    NSString *filename = [myfileGroup stringByAppendingFormat:@"/%@",@"downData"];
    return filename;
}

- (void)createFolder:(NSString *)createDir{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString*)getRequestHost{
    return @"";
}

- (NSDictionary*)getStaticParams{
    return @{};
}

- (NSDictionary*)headDataDic{
    if (_headDataDic==nil) {
        _headDataDic = @{}.mutableCopy;
    }
    return _headDataDic;
}

- (NSMutableDictionary*)getInfo{
    if (_getInfo == nil) {
        _getInfo =@{}.mutableCopy;
    }
    return  _getInfo;
}

- (NSDictionary*)getGetInfoStaticParams{
    return @{};
}

+ (void)hideNetworkActivityIndicator{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

@end
