//
//  HongbaoFloatView.h
//  Cooperation
//
//  Created by yangjuanping on 16/10/27.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HongbaoFloatView : UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *test;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
