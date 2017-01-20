//
//  SubjectTimetableViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/12/6.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "SubjectTimetableViewController.h"

@interface SubjectTimetableViewController ()

@end

@implementation SubjectTimetableViewController

AH_MAINITEMBASEVC_MODULE

-(MainCollectionIconItem*)getIconItem{
    MainCollectionIconItem* item = [[MainCollectionIconItem alloc]init];
    item.icon = @"headPic.jpg";
    item.iconUrl = @"";
    item.title = @"课程表";
    item.itemId = @"课程表";
    item.viewController = nil;
    return item;
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
