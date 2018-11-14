//
//  LZViewController.m
//  LZNet
//
//  Created by emailoflizheng@126.com on 11/13/2018.
//  Copyright (c) 2018 emailoflizheng@126.com. All rights reserved.
//

#import "LZViewController.h"
#import "LZExpressDataRequest.h"

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)beginRequest:(id)sender {
    [LZExpressDataRequest requestCommentWithParameters:nil withIndicatorView:self.view onRequestFinished:^(LZBaseDataRequest * _Nonnull request) {
        //请求成功
        if (request.isSuccess) {
            
        }
    } onRequestFailed:^(LZBaseDataRequest * _Nonnull request) {
        //请求失败
        
    }];
}


@end
