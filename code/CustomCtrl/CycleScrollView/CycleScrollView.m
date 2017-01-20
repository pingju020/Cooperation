//
//  CycleScrollView.m
//  CycleScrollView
//
//  Created by Leo on 15-4-2.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"

#define STARTTIME_DELAY 2
#define IMAGEVIEW_COUNT 3

@interface CycleScrollView () <UIScrollViewDelegate>

// 主scrollView
@property (nonatomic ,weak) UIScrollView *cycleScrollView;

// 当前页码数
@property (nonatomic, assign) NSInteger currentPageIndex;

// 数据源imageURL
@property (nonatomic ,strong) NSMutableArray *imageUrls;
// 内容数据源imageURL
@property (nonatomic ,strong) NSMutableArray *contentImageUrls;

// 定时器
@property (nonatomic ,strong) NSTimer *time;

@end

@implementation CycleScrollView

- (NSMutableArray *)imageUrls
{
    if (_imageUrls == nil) {
        _imageUrls = [[NSMutableArray alloc] init];
    }
    return _imageUrls;
}
- (NSMutableArray *)contentImageUrls
{
    if (_contentImageUrls == nil) {
        _contentImageUrls = [[NSMutableArray alloc] init];
    }
    return _contentImageUrls;
}

// 初始化函数
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[SDImageCache sharedImageCache] clearMemory];
        // Initialization code
        // 定制滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.cycleScrollView = scrollView;
        self.cycleScrollView.contentMode = UIViewContentModeCenter;
        self.cycleScrollView.delegate = self;
        self.cycleScrollView.bounces = NO;
        self.cycleScrollView.showsHorizontalScrollIndicator = NO;
        self.cycleScrollView.userInteractionEnabled = NO;
        self.cycleScrollView.pagingEnabled = YES;
        self.cycleScrollView.contentSize = CGSizeMake((IMAGEVIEW_COUNT) * CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:self.cycleScrollView];
        self.currentPageIndex = 0;
        // 添加三张imageview 用于复用
        [self addThreeImageView];
        
        // 初始化位置
        [self refreshLocation];
        
        // 创建page
        UIPageControl *page = [[UIPageControl alloc] init];
        [self addSubview:page];
        self.scrollPage = page;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.cycleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        /*UIViewAutoresizingNone                 = 0,
         UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
         UIViewAutoresizingFlexibleWidth        = 1 << 1,
         UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
         UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
         UIViewAutoresizingFlexibleHeight       = 1 << 4,
         UIViewAutoresizingFlexibleBottomMargin = 1 << 5
         */
    }
    return self;
}

// 创建三张imageView 用于滚动复用 占用内存小 当前和旁边的两张图片采用预加载
- (void)addThreeImageView
{
    for (UIView *view in self.cycleScrollView.subviews) {
        [view removeFromSuperview];
    }
    // 创建三张imageView 设置位置
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat W = CGRectGetWidth(self.cycleScrollView.frame);
        CGFloat H = CGRectGetHeight(self.cycleScrollView.frame);
        // frame放在5个中间
        imageView.frame = CGRectMake((i) * W , 0, W, H);
        // 添加手势
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self.cycleScrollView addSubview:imageView];

    }
}

// 设置数据源(默认是网上解析后的imageurl字符串数组)
- (void)setImageUrlNames:(NSArray *)ImageUrlNames
{
    for (NSString *name in ImageUrlNames) {
        [self.imageUrls addObject:[NSURL URLWithString:name]];
    }
    [self refreshImage];
    // 数据源设置page
    [self setupPage];
    
    self.cycleScrollView.userInteractionEnabled = YES;
}
// 初始化page
- (void)setupPage
{
    self.scrollPage.numberOfPages = self.imageUrls.count;
    CGFloat pageW = CGRectGetWidth(self.cycleScrollView.frame)/20*self.imageUrls.count;
    CGFloat pageH = 8;
    CGFloat pageX = CGRectGetWidth(self.cycleScrollView.frame)/2 - pageW/2;
    CGFloat pageY = CGRectGetMaxY(self.cycleScrollView.frame) - pageH - 5;
    self.scrollPage.frame = CGRectMake(pageX, pageY, pageW, pageH);
    self.scrollPage.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.3];
    self.scrollPage.layer.cornerRadius = pageH/2;
}

// 设置数据源 和 自动滚动时间
- (void)setImageUrlNames:(NSArray *)ImageUrlNames animationDuration:(NSTimeInterval)animationDuration
{
    // 创建定时器
    if (ImageUrlNames.count > 1) {
        [self createTime:animationDuration];
    }
    
    // 设置数据源
    [self setImageUrlNames:ImageUrlNames];
}
// 创建定时器
- (void)createTime:(NSTimeInterval)animationDuration
{
    self.time = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(timing) userInfo:nil repeats:YES];
    self.time.fireDate = [NSDate distantFuture];
    [[NSRunLoop mainRunLoop] addTimer:self.time forMode:NSRunLoopCommonModes];
}
// 定时方法
- (void)timing
{
    CGPoint newOffset = CGPointMake(self.cycleScrollView.contentOffset.x + CGRectGetWidth(self.cycleScrollView.frame), self.cycleScrollView.contentOffset.y);
    [self.cycleScrollView setContentOffset:newOffset animated:YES];
}
// 暂停定时器
- (void)pauseTime
{
    if (self.time) {
        if ([self.time isValid]) {
            self.time.fireDate = [NSDate distantFuture];
        }
    }
}
// 开始定时器
- (void)startTime
{
    if (self.time) {
        if ([self.time isValid]) {
            self.time.fireDate = [NSDate distantPast];
        }
    }
}
// 一段时间后开始定时器
- (void)startTimeWithDelay:(NSTimeInterval)delay
{
    if (self.time) {
        if ([self.time isValid]) {
            self.time.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
        }
    }
}

- (void)refreshImage
{
    if (self.imageUrls.count > 0) {
        [self refreshContentImageUrls];
        [self refreshImageView];
        
    }
}

// 刷新所有
- (void)refresh
{
    if (self.imageUrls.count > 0) {
        [self refreshImage];
        [self refreshLocation];
        [self refreshPage];
    }

}
// 刷新page的当前页
- (void)refreshPage
{
    self.scrollPage.currentPage = self.currentPageIndex;
}
// 刷新内容数据源
- (void)refreshContentImageUrls
{
    long prePage = self.currentPageIndex - 1 >= 0 ? self.currentPageIndex - 1 : self.imageUrls.count - 1;
    long nextPage = self.currentPageIndex + 1 < self.imageUrls.count ? self.currentPageIndex + 1 : 0;
    
    [self.contentImageUrls removeAllObjects];
    [self.contentImageUrls addObject:self.imageUrls[prePage]];
    [self.contentImageUrls addObject:self.imageUrls[self.currentPageIndex]];
    [self.contentImageUrls addObject:self.imageUrls[nextPage]];
    
}
// 刷新imageView的图片 使用sdwebimage第三方加载图片
- (void)refreshImageView
{
    [self pauseTime];
    
    __weak UIImageView *imageView1 = self.cycleScrollView.subviews[1];
    __weak UIImageView *imageView2 = self.cycleScrollView.subviews[2];
    __weak UIImageView *imageView0 = self.cycleScrollView.subviews[0];
    
    // 加载第当前图片
    
    // 随着库代码更改 需要更改下面代码
    [imageView1 sd_setImageWithURL:self.contentImageUrls[1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self startTimeWithDelay:STARTTIME_DELAY];
        // 加载下一个图片
        [imageView2 sd_setImageWithURL:self.contentImageUrls[2] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 加载前一个图片
            [imageView0 sd_setImageWithURL:self.contentImageUrls[0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }];
        
    }];
    
}
// 刷新位置
- (void)refreshLocation
{
    self.cycleScrollView.contentOffset = CGPointMake((int)((IMAGEVIEW_COUNT)/2)*CGRectGetWidth(self.cycleScrollView.frame), 0);
    if ([self.delegate respondsToSelector:@selector(cycleScrollview:ValueChanged:)]) {
        [self.delegate cycleScrollview:self ValueChanged:self.currentPageIndex];
    }
}


#pragma mark - 监听scroll
// 滚动动画结束时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimeWithDelay:STARTTIME_DELAY];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseTime];
}
// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == (IMAGEVIEW_COUNT - 3) * CGRectGetWidth(self.cycleScrollView.frame)) {
        self.currentPageIndex = self.currentPageIndex - 1 >= 0 ? self.currentPageIndex - 1 : self.imageUrls.count - 1;
        [self refresh];
        
    } else if (scrollView.contentOffset.x == (IMAGEVIEW_COUNT-1) * CGRectGetWidth(self.cycleScrollView.frame)) {
        self.currentPageIndex = self.currentPageIndex + 1 < self.imageUrls.count ? self.currentPageIndex + 1 : 0;
        [self refresh];
    }
}

#pragma mark - 响应事件

// imageView的点击事件
- (void)imageViewTapAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:DidTapImageView:)]) {
        [self.delegate cycleScrollView:self DidTapImageView:self.currentPageIndex];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


@end
