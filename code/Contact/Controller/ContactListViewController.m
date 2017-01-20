//
//  ContactListViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/26.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "ContactListViewController.h"
#import "PJTabBarItem.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController

AH_BASESUBVCFORMAINTAB_MODULE

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"通话";
    itemMainHome.strNormalImg = @"";
    itemMainHome.strSelectImg = @"";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 3;
    title.text = itemMainHome.strTitle;
    return itemMainHome;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
