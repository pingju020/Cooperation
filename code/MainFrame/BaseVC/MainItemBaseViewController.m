//
//  MainItemBaseViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/29.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainItemBaseViewController.h"

@interface MainItemBaseViewController ()

@end

@implementation MainItemBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInitialize{
    ;
}

-(void)ShowMainItemViewController:(UIViewController*)parentVC{
    [parentVC.navigationController pushViewController:self animated:YES];
}

-(MainCollectionIconItem*)getIconItem{
    // 必须在子类中实现
    [self doesNotRecognizeSelector:@selector(getIconItem)];
    return nil;
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
