//
//  WebViewViewController.h
//  xxt_xj
//
//  Created by Yang on 15/2/12.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import "BaseViewController.h"

@protocol WebViewViewControllerDelegate <NSObject>

@optional
//向当前委托指向的控制器回抛数据
- (void)onOpenNewWindow;
@end

@interface WebViewViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, assign)id<WebViewViewControllerDelegate> webDelegate;
@property (nonatomic, strong) UIWebView *currentWebView;
@property (nonatomic, strong) NSString *actionUrl;
@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *monitorParam;

- (instancetype)initWithParameter:(NSString *)url monitorParam:(NSString *)MonitorParam fromAdv:(BOOL)fromAdv;

@end
