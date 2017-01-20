//
//  ChooseJoinViewController.m
//  anhui
//
//  Created by 葛君语 on 16/5/16.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "ChooseJoinViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RegisterModel.h"
#import "SelectRoleViewController.h"
#import "HttpLoginAndRegister.h"

@interface ChooseJoinViewController ()

@end

@implementation ChooseJoinViewController

- (instancetype)init
{
    NSString *url = [NSString stringWithFormat:@"%@/educloud/ucenter/html5/indexNew",[HTTP_MANAGER getXjServer]];
    
    self = [super initWithParameter:url monitorParam:nil fromAdv:NO];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    title.text = @"选择学校";
}

- (void)configJSContext
{
    JSContext *context = [self.currentWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"toRegisterInviteSchool"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *school_id   = [NSString stringWithFormat:@"%@",args[0]];
        NSString *school_name = [NSString stringWithFormat:@"%@",args[1]];
        
        //获取数据
        [self requestModelWithSchool_id:school_id
                            school_name:school_name];
        
    };
    
    //旧
//    context[@"gotoPager"] = ^(){
//        NSString *titleStr = [NSString stringWithFormat:@"%@",[JSContext currentArguments][0]];
//        
//        self.title = titleStr;
    //    };
    
    
    //        context[@"toRegisterInviteClazz"] = ^(){
    //            NSArray *args = [JSContext currentArguments];
    //
    //            NSString *gradeId   = [NSString stringWithFormat:@"%@",args[0]];
    //            NSString *classId   = [NSString stringWithFormat:@"%@",args[1]];
    //            NSString *className = [NSString stringWithFormat:@"%@",args[2]];
    //
    //
    //            VerifyPhoneNum *vc = [[VerifyPhoneNum alloc]initWithClassName:className GradeId:gradeId ClassId:classId];
    //            [self.navigationController pushViewController:vc animated:YES];
//        };

}

#pragma mark -获取年级班级信息
- (void)requestModelWithSchool_id:(NSString *)school_id school_name:(NSString *)school_name
{
    [self showWaitingView];
    [LOGIN_REGISTER queryGradeAndClassWithSchool_id:school_id
                                   successedBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
                                       [self removeWaitingView];
                                       if (isSucceed) {
                                           //获取成功
                                           RegisterModel *model = [RegisterModel shared];
                                           model.schoolId   = school_id;
                                           model.schoolName = school_name;
                                           
                                           NSArray *gradeList = [GradeListModel parsingGradeListWithList:succeedResult[@"gradeList"]];
                                           if (IsArrEmpty(gradeList)) {
                                               [PubllicMaskViewHelper showTipViewWith:@"该校没有年级" inSuperView:self.view withDuration:1];
                                               return ;
                                           }
                                           
                                           SelectRoleViewController *vc = [[SelectRoleViewController alloc]initWithIsSelectRole:NO];
                                           vc.gradeList = gradeList;
                                           [self.navigationController pushViewController:vc animated:YES];
                                           
                                       }else{
                                           [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                       }
                                       
                                   }
                                      failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
                                          [self removeWaitingView];
                                          [PubllicMaskViewHelper showTipViewWith:@"网络异常" inSuperView:self.view withDuration:1];
                                      }];
}

-(void)backBtnClicked
{
    if (self.currentWebView.canGoBack) {
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
        [self.currentWebView goBack];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //这里有个BUG，响应点击事件会跳转一个404页面，原因未知
    if ([request.URL.absoluteString hasSuffix:@"undefined"]) {
        return NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configJSContext];
    });
    
    return YES;
}

@end
