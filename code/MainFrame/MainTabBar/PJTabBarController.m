//
//  PJTabBarController.m
//  PJRichText
//
//  Created by yangjuanping on 15/11/18.
//  Copyright © 2015年 yangjuanping. All rights reserved.
//

#import "SystemDefine.h"
#import "PJTabBarController.h"
#import "PJTabbarButtonsBGView.h"
#import "BaseViewController.h"
#import "MainTabLoadContext.h"

@interface PJTabBarController ()<PJTabbarButtonsDelegate>
@property(nonatomic,strong)NSArray *arrBarItems;
@property(nonatomic,retain)PJTabbarButtonsBGView* tabBarNew;
@end

@implementation PJTabBarController
- (id)init
{
    self = [super init];
    if (self)
    {
        [self initTabbarAndView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 主界面禁用左上角的返回按钮
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化tabbar
-(void)initTabbarAndView{
    _arrBarItems = [[MainTabLoadContext sharedInstance]getMainTabModuleData];
    
    PJTabbarButtonsBGView * tabar = [[PJTabbarButtonsBGView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM, MAIN_WIDTH, HEIGHT_MAIN_BOTTOM) withBarItems:_arrBarItems];
    tabar.delegate = self;
    [self.view addSubview:tabar];
    self.tabBarNew = tabar;
    
    NSMutableArray* viewArr = [[NSMutableArray alloc]init];
    
    for (PJTabBarItem* item in _arrBarItems) {
        [viewArr addObject:item.viewController];
    }
    
    self.viewControllers = [NSArray arrayWithArray:viewArr];
    [self onSelectedWithButtonIndex:0];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- PJTabbarButtonsDelegate
-(void)onSelectedWithButtonIndex:(NSInteger)index{
    self.selectedIndex = index;
    [self.tabBarNew refreshWithCurrentSelected:index];
    
    PJTabBarItem *item = _arrBarItems[index];
    self.title = item.strTitle;
    
}

@end
