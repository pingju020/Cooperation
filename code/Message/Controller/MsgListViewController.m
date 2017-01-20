//
//  MsgListViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MsgListViewController.h"
#import "PJTabBarItem.h"

@interface MsgListViewController ()

@end

@implementation MsgListViewController

AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"消息";
    itemMainHome.strNormalImg = @"";
    itemMainHome.strSelectImg = @"";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 2;
    title.text = itemMainHome.strTitle;
    return itemMainHome;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
