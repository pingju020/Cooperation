//
//  JoinClassViewController.m
//  anhui
//
//  Created by 葛君语 on 2016/10/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "JoinClassViewController.h"
#import "JoinClassButton.h"
#import "SmsCodeViewController.h"
#import "ChooseJoinViewController.h"

@interface JoinClassViewController ()

@property (nonatomic,strong) UILabel *tipLabel; //提示语

@end

@implementation JoinClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入班级";
    self.view.backgroundColor = VcBackgroudColor;
    
    [self setButtons];
}


- (void)btnClicked:(JoinClassButton *)sender
{
    switch (sender.tag) {
        case 100: //班级码加入
        {
            [self.navigationController pushViewController:[[SmsCodeViewController alloc]initWithClassCode] animated:YES];
        }
            break;
            
        case 101: //选择班级加入
        {
            [self.navigationController pushViewController:[ChooseJoinViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -setUI
- (void)setButtons
{
    NSArray *arr = @[@{@"icon":@"Register_book",
                       @"title":@"通过班级码方式加入",
                       @"tip":@"班级码为班级内教师或家长发送的一串邀请码,您可以通过输入邀请码快速加入到某个班级"},
                     @{@"icon":@"Register_star",
                       @"title":@"查找班级方式加入",
                       @"tip":@"您可以根据孩子所在的学校、年级、班级选择加入"}];
    
    CGFloat buttonH = MAIN_HEIGHT*0.133;
    CGFloat space   = 10; //上下间距
    
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        JoinClassButton *btn = [[JoinClassButton alloc]initWithFrame:CGRectMake(15, navigationBG.bottom+space+(buttonH+space)*idx, MAIN_WIDTH-30, buttonH)];
        
        btn.imageName = dict[@"icon"];
        btn.title     = dict[@"title"];
        btn.tip       = dict[@"tip"];
        btn.tag       = idx+100;
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
        
        if (idx == arr.count-1) {
            self.tipLabel.top = btn.bottom+30;
        }
        
    }];
    
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        _tipLabel.centerX = MAIN_WIDTH/2;
        _tipLabel.text = @"请选择加入班级方式";
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
