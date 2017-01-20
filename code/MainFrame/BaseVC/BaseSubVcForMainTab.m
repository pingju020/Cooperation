//
//  BaseSubVcForMainTab.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "BaseSubVcForMainTab.h"
#import "PJTabBarItem.h"

@interface BaseSubVcForMainTab ()

@end

@implementation BaseSubVcForMainTab

-(PJTabBarItem*)getTabBarItem{
    [self doesNotRecognizeSelector:@selector(getTabBarItem)];
//    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"getTabBarItem 方法必须在BaseSubVcForMainTab子类中实现后再使用" userInfo:nil];
    return nil;
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
