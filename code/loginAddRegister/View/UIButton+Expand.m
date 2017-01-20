//
//  UIButton+Expand.m
//  Foundation
//
//  Created by 葛君语 on 16/5/24.
//  Copyright © 2016年 Gejunyu. All rights reserved.
//

#import "UIButton+Expand.h"
#import <objc/runtime.h>

static const void *associatedKey = "associatedKey";

@implementation UIButton (Expand)

#pragma mark -倒计时
- (void)countDownWithStartTime:(NSInteger)timeout
              waitTitleForward:(NSString *)forward
                      backward:(NSString *)backward
{
    //不可点击
    self.userInteractionEnabled = NO;
    self.selected = YES;
    
    //保存原有标题
    NSString *originTitle = self.currentTitle;
    
    [self countDownWithStartTime:timeout
                        progress:^(NSInteger lastTime) {
                            //设置界面的按钮显示
                            [self setTitle:[NSString stringWithFormat:@"%@%li%@",forward,lastTime,backward] forState:UIControlStateNormal];
                        }
                      completion:^{
                          [self setTitle:originTitle forState:UIControlStateNormal];
                          self.userInteractionEnabled = YES;
                          self.selected = NO;
                      }];

    
    
}

- (void)countDownWithStartTime:(NSInteger)timeout
                      progress:(void (^)(NSInteger))progress
                    completion:(void (^)())completion
{
    //倒计时时间
    __block NSInteger lastTime = timeout;
    
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    //处理
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束
        if(lastTime<=0){
            //关闭线程
            dispatch_source_cancel(_timer);
            
            //主线程 恢复标题 和 可点击
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
            
        }else{
            //            NSInteger minutes = timeout / 60;
            //            NSInteger seconds = timeOut % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%.2ld分%.2ld秒", minutes,seconds];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(lastTime--);
            });

            
        }

    });

    dispatch_resume(_timer);
}

#pragma mark -点击事件
//Category中的属性，只会生成setter和getter方法，不会生成成员变量

- (void)setClick:(void (^)())click{
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void(^)())click{
    return objc_getAssociatedObject(self, associatedKey);
}

- (void)buttonClick{
    if (self.click) {
        self.click();
    }
}

@end
