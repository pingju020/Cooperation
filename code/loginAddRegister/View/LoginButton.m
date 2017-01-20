//
//  LoginButton.m
//  anhui
//
//  Created by 葛君语 on 2016/10/24.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self setBackgroundImage:[UIImage imageNamed:@"loginGreenBtn"] forState:UIControlStateNormal];
}

@end
