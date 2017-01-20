//
//  ViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/11.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "ViewController.h"
#import "PJTabBarController.h"
#import "HttpLoginAndRegister.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
//    [[HttpLoginAndRegister sharedInstance]startLoginWithAccount:@"15105518775" pwdCode:@"1234" role:@"1" successedBlock:^(NSDictionary *succeedResult) {
//        NSLog(@"startLoginWithAccount successed!");
//    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
//        NSLog(@"startLoginWithAccount failed!");
//    }];
    
    PJTabBarController* vc = [[PJTabBarController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

//- (void)startLoginWithAccount:(NSString *)account
//                      pwdCode:(NSString *)pwdCode
//                         role:(NSString *)role
//               successedBlock:(SuccessedBlock)success
//                  failedBolck:(FailedBlock)failed
//{
//    NSDictionary *param = @{@"commandtype":@"login",
//                            @"term_manufacturer":TERM_MANU,
//                            @"account":account,
//                            @"password":pwdCode,
//                            @"extend":EmptyToken,
//                            @"origin":@"ios",
//                            @"user_type":role};
//    
//    [self startNormalPostWith:XJ_SERVER_NEW
//                     paragram:param
//               successedBlock:success
//                  failedBolck:failed];
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
