//
//  LZBaseDataRequest.h
//  LZNet_Example
//
//  Created by lizheng on 2018/11/13.
//  Copyright © 2018年 emailoflizheng@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LZRequestResult.h"
#import "LZRequestDataHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    LZURLParameterEncoding,//普通的http的编码格式，二进制
    LZJSONParameterEncoding,//
    LZPropertyListParameterEncoding,
    LZUploadParameterEncoding,//上传
    LZDownParameterEncoding,//下载
} LZParameterEncoding;

typedef enum : NSUInteger{
    LZRequestMethodGet = 0,
    LZRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    LZRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"//用于文件相关
    LZRequestMethodGetAndPost = 3,  //同时上传GetPost
    LZRequestMethodPut, //暂缓开通
    LZRequestMethodDelete,//暂缓开通
    LZRequestMethodHead,//暂缓开通
} LZRequestMethod;

//上传路径还是数据
typedef enum {
    LZUpLoadData,
    LZUpLoadDataPath
}LZUpLoadDataType;

@class ZJRequestDataHandler;
@class ZJBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(ZJBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ZJBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ZJBaseDataRequest*)request;
- (void)request:(ZJBaseDataRequest*)request progressChanged:(float)progress;
- (void)request:(ZJBaseDataRequest*)request didFailLoadWithError:(NSError*)error;

@end

@interface LZBaseDataRequest : NSObject
{
    NSString    *_cancelSubject;
    NSString    *_filePath;
    NSDate      *_requestStartDate;
    BOOL        _useSilentAlert;
    //progress related
    long long   _totalData;
    long long   _downloadedData;
    CGFloat     _downProgress;
    CGFloat     _updateProgress;
    
    void (^_onRequestStartBlock)(LZBaseDataRequest *);
    void (^_onRequestFinishBlock)(LZBaseDataRequest *);
    void (^_onRequestCanceled)(LZBaseDataRequest *);
    void (^_onRequestFailedBlock)(LZBaseDataRequest *, NSError *);
    void (^_onRequestProgressChangedBlock)(LZBaseDataRequest *, CGFloat);
    void (^_onRequestProgressUpdateBlock)(LZBaseDataRequest *,CGFloat);
}

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat  downProgress;
@property (nonatomic, assign) CGFloat updateProgress;
@property (nonatomic, assign) LZParameterEncoding parmaterEncoding;
@property (nonatomic, strong) id handleredResult;///返回的完整结果
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, copy) NSString *rawResultString;
@property (nonatomic, strong) LZRequestResult *result;///将返回结果对象化
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) BOOL isNULLData;
@property (nonatomic, strong, readonly) LZRequestDataHandler *requestDataHandler;
@property (nonatomic, assign) LZUpLoadDataType upLoadDataType;
@property (nonatomic, strong) NSString *downPath;
@property (nonatomic, strong) id updata;//NSData类型或NSString类型
@property (nonatomic, strong) NSNumber *timeoutInterval;
@property (nonatomic, strong) NSString *fileSuffix;
@property (nonatomic, strong) NSDictionary *headDataDic;///报文头
// request identifier userinfo
@property (nonatomic, strong) NSDictionary *userinfo;//上传的post参数
@property (nonatomic, strong) NSMutableDictionary *getInfo;///上传的get参数
@property (nonatomic, strong) NSError *error;

@property (nonatomic,copy)void (^onRequestStartBlock)(LZBaseDataRequest *);
@property (nonatomic,copy)void (^onRequestFinishBlock)(LZBaseDataRequest *);
@property (nonatomic,copy)void (^onRequestCanceled)(LZBaseDataRequest *);
@property (nonatomic,copy)void (^onRequestFailedBlock)(LZBaseDataRequest *, NSError *);
@property (nonatomic,copy)void (^onRequestProgressChangedBlock)(LZBaseDataRequest *,  CGFloat);
@property (nonatomic,copy)void (^onRequestProgressUpdateBlock)(LZBaseDataRequest *,  CGFloat);


///开始请求
- (void)beginRequest;
#pragma mark - init methods using delegate

+ (NSString*)toString;

#pragma mark - init methods using blocks

/**
 *请求时显示hud ,如果自定义需在子类中重写
 */
- (void)showHUDInView:(UIView *)indicatorView;

/**
 *请求时显示hud ,如果自定义需在子类中重写
 */
- (void)hideHUDToView:(UIView *)indicatorView;

/**
 *  常用 直接指定URL
 *
 *  @param params          传入字典
 *  @param url             请求URL
 *  @param indiView        loadingView
 *  @param onFinishedBlock 成功返回
 *
 *  @return self
 */
+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock;
/**
 *  常用
 *
 *  @param params          传入字典
 *  @param onFinishedBlock 成功返回
 *  @param onFailedBlock   失败返回
 *
 *  @return self
 */
+ (id)requestCommentWithParameters:(NSDictionary*)params
                onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                  onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;
- (id)requestCommentWithParameters:(NSDictionary*)params
                onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                  onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;
/**
 *  常用  带hud
 *
 *  @param params          传入字典
 *  @param IndicatorView loadingView
 *  @param onFinishedBlock 成功返回
 *  @param onFailedBlock   失败返回
 *
 *  @return self
 */
+ (id)requestCommentWithParameters:(NSDictionary*)params
                withIndicatorView:(UIView*)indicatorView
                onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                  onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;
- (id)requestCommentWithParameters:(NSDictionary*)params
                withIndicatorView:(UIView*)indicatorView
                onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                  onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;
/**
 *  常用  只有成功block
 *
 *  @param params          传入字典
 *  @param indiView        loadingView
 *  @param onFinishedBlock 成功返回
 *
 *  @return self
 */
+ (id)requestCommentWithParameters:(NSDictionary*)params
                 withIndicatorView:(UIView*)indiView
                 onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock;
- (id)requestCommentWithParameters:(NSDictionary*)params
                 withIndicatorView:(UIView*)indiView
                 onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock;


/**
 用作同时带有get和post的请求，且有loadingView
 
 @param getParams get请求的字典
 @param postParams post请求的字典
 @param indiView loadingView
 @param onFinishedBlock 成果返回
 @param onFailedBlock 失败返回
 @return 返回对象自身
 */
+ (id)requestCommentWithGetParameters:(NSDictionary<NSString *,NSString*>*)getParams
                       postParameters:(NSDictionary*)postParams
                    withIndicatorView:(UIView*)indiView
                    onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                      onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;
/**
 用作同时带有get和post的请求
 
 @param getParams get请求的字典
 @param postParams post请求的字典
 @param onFinishedBlock 成果返回
 @param onFailedBlock 失败返回
 @return 返回对象自身
 */
+ (id)requestCommentWithGetParameters:(NSDictionary<NSString *,NSString*>*)getParams
                       postParameters:(NSDictionary*)postParams
                    onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
                      onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;

/**
 *  常用 带接口取消通知
 *
 *  @param params          传入字典
 *  @param indiView        loadingView
 *  @param cancelSubject   取消通知字段
 *  @param onFinishedBlock 成功返回
 *
 *  @return self
 */
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock;


+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
            onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;

+ (id)requestWithSuffixParam:(NSString*)suffixParam
                  parameters:(NSDictionary*)params
           withIndicatorView:(UIView*)indiView
           withCancelSubject:(NSString*)cancelSubject
           onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
             onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock;

//上传
+ (id)requestWithUpLoadDataPath:(NSString*)dataPath
                    parameters:(NSDictionary*)params
             withCancelSubject:(NSString*)cancelSubject
                onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
             onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
             onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
               onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
       onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress;


+ (id)requestWithUpLoadData:(NSData*)data
                parameters:(NSDictionary*)params
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress;

+ (id)requestWithUpLoadData:(NSData*)data
                parameters:(NSDictionary*)params
                    suffix:(NSString*)suffix
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress;

//下载
+ (id)requestDownUrlString:(NSString*)url
               parameters:(NSDictionary*)params
                 downPath:(NSString*)downPath
            cancelSubject:(NSString*)cancelSubject
           onRequestStart:(void(^)(LZBaseDataRequest *request))onStartBlock
        onRequestFinished:(void(^)(LZBaseDataRequest *request))onFinishedBlock
        onRequestCanceled:(void(^)(LZBaseDataRequest *request))onCanceledBlock
          onRequestFailed:(void(^)(LZBaseDataRequest *request))onFailedBlock
 onRequestProgressChanged:(void(^)(LZBaseDataRequest *request,CGFloat progress))onRequestProgress;

/**
 *  核心方法
 *
 *  @param params                 传入字典
 *  @param url                    访问url
 *  @param indiView               如果有loading放置view
 *  @param loadingMessage         loading文字
 *  @param cancelSubject          取消的标志
 *  @param silent                 是否隐藏网络错误提示
 *  @param localFilePath          文件路径
 *  @param onStartBlock           开始请求的block
 *  @param onFinishedBlock        正确返回的block
 *  @param onCanceledBlock        取消请求的block
 *  @param onFailedBlock          请求失败的block
 *  @param onProgressChangedBlock 请求网络的进度
 *
 *  @return self
 */
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
       onProgressChanged:(void(^)(LZBaseDataRequest *request,float))onProgressChangedBlock;

#pragma mark - file download related init methods


- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error;
- (void)notifyDelegateRequestDidSuccess;
- (void)doRelease;
//对于结果的处理
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;                                     //subclass should override the method to cancel its request
- (void)showNetowrkUnavailableAlertView:(NSString*)message;
- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)isSuccess;
- (BOOL)handleResultDic:(NSMutableDictionary*)resultDic;
- (BOOL)processDownloadFile;
/**
 *  请求方式
 *
 *  @return LZRequestMethod
 */
- (LZRequestMethod)getRequestMethod;                       //default method is GET
/**
 *  编码格式
 *
 *  @return NSStringEncoding
 */
- (NSStringEncoding)getResponseEncoding;

- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;
///静态的参数 
- (NSDictionary*)getStaticParams;
///静态GET数据  LZRequestMethod==LZRequestMethodGetAndPost 时有用
- (NSDictionary*)getGetInfoStaticParams;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;
- (NSString*)downPath;
/**
 子类重写次方法，静态HEAD
 @return 返回一个新的dic
 */
- (NSDictionary*)headDataDic;

@end

NS_ASSUME_NONNULL_END
