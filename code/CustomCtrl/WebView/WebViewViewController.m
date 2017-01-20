//
//  WebViewViewController.m
//  xxt_xj
//
//  Created by Yang on 15/2/12.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "WebViewViewController.h"
#import "XXTEncrypt.h"
#import "ConverUtil.h"
#import "DataBaseModel.h"
#import "NSDictionary+ValueCheck.h"
//#import "KxMovieViewController.h"
@interface WebViewViewController ()
{
    BOOL isFromAdv;
}

@property (nonatomic,copy)NSString * appURL;
@property (nonatomic,copy)NSString * appID;
@property (nonatomic,copy)NSString * appSourceid;
@end

@implementation WebViewViewController
- (instancetype)initWithParameter:(NSString *)url monitorParam:(NSString *)MonitorParam fromAdv:(BOOL)fromAdv
{
    self = [super init];
    if (self) {
        self.actionUrl = url;
        self.monitorParam = MonitorParam;
        isFromAdv = fromAdv;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    title.text = self.appName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentWebView.frame = CGRectMake(0,CGRectGetMaxY(navigationBG.frame),MAIN_WIDTH, MAIN_HEIGHT - CGRectGetMaxY(navigationBG.frame));
        if (isFromAdv)//广告
        {
            if ([_monitorParam isEqualToString:@"1"])//广告带参数
            {
                //LoginReturnInfoDTO *dto = [sqliteADO queryLoginUserReturnInfo:[[NSUserDefaults standardUserDefaults] valueForKey:KEY_REMOTEID]];
                //NSString *extendAds = @"E+4YwN1FJDgbpPSm2NT+mA02Np+GTG6Va6Wydr3RXedJ16AsWvnIrwgG70qk KCzH";
                NSString* strUserId = @""; //[LoginUserUtil userId]
                NSString* strUserType = @"1"; //[LoginUserUtil userType]
                NSString *extendAds = [XXTEncrypt extendDESWithAds:strUserId userType:strUserType];
                NSString *originAds = @"activitys";
                NSDictionary *dic = @{
                                      @"extend":extendAds,
                                      @"origin":originAds,
                                      };
                dic = [dic addAdsSigdic:(NSMutableDictionary *)dic];
                NSString *sigAds = dic[@"sig"];
    
                NSString *extendAdsUrlEncode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)extendAds,NULL,CFSTR("!'();:@&=+$,/?%#[]~"),kCFStringEncodingUTF8));
                NSString *originAdsUrlEncode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)originAds,NULL,CFSTR("!'();:@&=+$,/?%#[]~"),kCFStringEncodingUTF8));
                NSString *sigAdsUrlEncode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sigAds,NULL,CFSTR("!'();:@&=+$,/?%#[]~"),kCFStringEncodingUTF8));
    
    
                NSURL *url = [NSURL URLWithString:self.actionUrl];
                NSString *body = [NSString stringWithFormat: @"extend=%@&origin=%@&sig=%@", extendAdsUrlEncode,originAdsUrlEncode,sigAdsUrlEncode];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                //NSString *strBase64 = [ConverUtil base64Encoding:[body dataUsingEncoding:NSUTF8StringEncoding]];
                //[request setHTTPBody:[strBase64 dataUsingEncoding:NSUTF8StringEncoding]];
                [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
                [self.currentWebView loadRequest: request];
            }
            else//广告不带参数
            {
                [self.currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.actionUrl]]];
            }
            
            return;
        }
    
    // 应用带参数
    if ([self.monitorParam length]>0) {
        NSURL *url = [NSURL URLWithString:self.actionUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [self.monitorParam dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
        SpeLog(@"%@",request.URL);
        [self.currentWebView loadRequest: request];
        return;
    }
    
    //应用不带参数
    [self.currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.actionUrl]]];
}
- (UIWebView *)currentWebView {
    if (!_currentWebView) {
        _currentWebView = [[UIWebView alloc] init];
        _currentWebView.delegate = self;
        [_currentWebView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_currentWebView];
    }
    return _currentWebView;
}
- (void)backBtnClicked
{
    if (self.presentingViewController || !self.navigationController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request);
    if ([request.URL.absoluteString rangeOfString:@"playvideo:*&%5E"].length > 0) {
        NSString *videoPath = [request.URL.absoluteString substringFromIndex:15];
        if ([videoPath length]>0) {
            
            if ([videoPath.pathExtension isEqualToString:@"flv"]) {
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                // increase buffering for .wmv, it solves problem with delaying audio frames
//                if ([videoPath.pathExtension isEqualToString:@"wmv"])
//                    parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
//                
//                // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
//                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//                    parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
//                
//                KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:videoPath
//                                                                                           parameters:parameters];
//                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                [self.currentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoPath]]];
            }
        }
        else{
            if (self.webDelegate && [self.webDelegate respondsToSelector:@selector(onOpenNewWindow)]) {
                [self.webDelegate onOpenNewWindow];
            };
        }
        return NO;
    }
    if (self.webDelegate && [self.webDelegate respondsToSelector:@selector(onOpenNewWindow)]) {
        [self.webDelegate onOpenNewWindow];
    };
    return YES;
}
@end
