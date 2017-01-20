//
//  BigImageViewController.h
//  anhui
//
//  Created by yangjuanping on 16/9/22.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol BigImageViewControllerDelegate <NSObject>
-(void)deleteImage:(NSInteger)index;
@end

@interface BigImageViewController : BaseViewController
-(id)initWithImages:(NSMutableArray*)arrImages showIndex:(NSInteger)index;
-(id)initWithImages:(NSMutableArray*)arrImages showIndex:(NSInteger)index showDel:(BOOL)showDelBtn;
@property(nonatomic,assign) id<BigImageViewControllerDelegate> delegate;
@end
