//
//  NewFeatureViewController.m
//  JZH_BASE
//
//  Created by Points on 13-11-22.
//  Copyright (c) 2013年 Points. All rights reserved.
//
#define NUM_PAGE 3

#import "NewFeatureViewController.h"
#import "LoginNewController.h"
@interface NewFeatureViewController ()<UIScrollViewDelegate>
{
    UIScrollView *m_scroller;
    UIPageControl *m_page;
}

@end

@implementation NewFeatureViewController
- (void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
   
    }
    return self;
}

- (void)startBtnClicked
{
    [[NSUserDefaults standardUserDefaults]setObject:NOT_FIRST_LAUNCH forKey:IS_FIRST_LAUNCH];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController pushViewController:[[LoginNewController alloc]init] animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    [self.navigationController setHidesBottomBarWhenPushed: YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    m_scroller = [[UIScrollView alloc]initWithFrame:MAIN_FRAME];
    [m_scroller setBackgroundColor:[UIColor clearColor]];
    m_scroller.delegate  = self;
    [m_scroller setContentSize:CGSizeMake(MAIN_WIDTH*NUM_PAGE, 0)];
    m_scroller.pagingEnabled = YES;
    m_scroller.directionalLockEnabled = YES;
    m_scroller.alwaysBounceVertical = NO;
    m_scroller.showsHorizontalScrollIndicator= NO;
    m_scroller.showsVerticalScrollIndicator= NO;
    [self.view addSubview:m_scroller];
    
    NSString *deviceFlag = @"5";
//    if (is_iPhone4_4s) {
//        deviceFlag = @"3.5";
//    } else if (is_iPhone5) {
//        deviceFlag = @"4";
//    } else if (is_iPhone6) {
//        deviceFlag = @"4.7";
//    } else if (is_iPhone6_plus) {
//        deviceFlag = @"5.5";
//    }
    deviceFlag = @"4.7";
    
    for (int i =0 ; i<NUM_PAGE; i++)
    {
        UIImageView *newFeatureImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*MAIN_WIDTH, 0, MAIN_WIDTH, MAIN_HEIGHT)];
        newFeatureImage.userInteractionEnabled = YES;
        
        NSString *name = [NSString stringWithFormat:@"welcome_%@_%@.jpg", deviceFlag, @(i+1)];
        [newFeatureImage setImage:[UIImage imageNamed:name]];
        
        if(i==NUM_PAGE-1)
        {
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundColor:[UIColor clearColor]];
            [startBtn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [startBtn setFrame:CGRectMake(80, MAIN_HEIGHT-60, MAIN_WIDTH/2, 40)];
            [newFeatureImage addSubview:startBtn];
        }
        
        [m_scroller addSubview:newFeatureImage];
    }
    
    m_page= [[UIPageControl alloc]initWithFrame:CGRectMake((MAIN_WIDTH-80)/2,MAIN_HEIGHT-40,80, 20)];
    [m_page setBackgroundColor:[UIColor clearColor]];
    m_page.numberOfPages = NUM_PAGE;
    if(OS_ABOVE_IOS6)
    {
        m_page.pageIndicatorTintColor = [UIColor whiteColor];
        m_page.currentPageIndicatorTintColor = UIColorFromRGB(0x1583AC);
    }
    [self.view addSubview:m_page];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - 

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if((int)scrollView.contentOffset.x > (NUM_PAGE-1)*MAIN_WIDTH+20)
    {
        [[NSUserDefaults standardUserDefaults]setObject:NOT_FIRST_LAUNCH forKey:IS_FIRST_LAUNCH];  //被移到家校圈中实现了
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //     pageControl.currentPage = page.currentPage;
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    m_page.currentPage = currentPage;
}


@end
