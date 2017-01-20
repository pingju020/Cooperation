//
//  BigImageViewController.m
//  anhui
//
//  Created by yangjuanping on 16/9/22.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * arrImages;
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,assign)NSInteger nIndex;
@property(nonatomic,assign)BOOL bShowNavigation;
@property(nonatomic,assign)BOOL bShowDel;
@property(nonatomic,strong)NSArray* arrImageViews;
@end

@implementation BigImageViewController

-(id)initWithImages:(NSMutableArray*)arrImages showIndex:(NSInteger)index{
    if (self = [super init]) {
        _arrImages = arrImages;
        _nIndex = index;
        _bShowNavigation = NO;
        _bShowDel = NO;
    }
    return self;
}

-(id)initWithImages:(NSMutableArray*)arrImages showIndex:(NSInteger)index showDel:(BOOL)showDelBtn{
    if (self = [super init]) {
        _arrImages = arrImages;
        _nIndex = index;
        _bShowNavigation = NO;
        _bShowDel = showDelBtn;
    }
    return self;
}


-(UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH , MAIN_HEIGHT)];
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake((MAIN_WIDTH) * _arrImages.count, MAIN_HEIGHT);
        _scrollView.tag = 501;
        [_scrollView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:_scrollView];
        
        NSMutableArray *arrViewImage = [[NSMutableArray alloc]init];
        for (NSUInteger i = 0; i < _arrImages.count; i++) {
            UIImage * image = _arrImages[i];
            
            CGFloat fVscal = image.size.height/MAIN_HEIGHT;
            CGFloat fHscal = image.size.width/MAIN_WIDTH;
            CGFloat fScal = fVscal>fHscal?fVscal:fHscal;
            CGFloat fImageViewHeight = image.size.height/fScal;
            CGFloat fImageViewWidth = image.size.width/fScal;
            
            UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(i*MAIN_WIDTH+MAIN_WIDTH/2-fImageViewWidth/2, MAIN_HEIGHT/2-fImageViewHeight/2, fImageViewWidth, fImageViewHeight);
            [_scrollView addSubview:imageView];
            [arrViewImage addObject:imageView];
        }
        _arrImageViews = arrViewImage;
        [_scrollView setContentOffset:CGPointMake(_nIndex * MAIN_WIDTH, 0)];
    }
    return _scrollView;
}

-(void)reloadImages{
    _scrollView.contentSize = CGSizeMake((MAIN_WIDTH) * _arrImages.count, MAIN_HEIGHT);
    [_scrollView setContentOffset:CGPointMake(_nIndex * MAIN_WIDTH, 0)];
    for (NSUInteger i = 0; i < _arrImages.count; i++) {
        UIImage * image = _arrImages[i];
        
        CGFloat fVscal = image.size.height/MAIN_HEIGHT;
        CGFloat fHscal = image.size.width/MAIN_WIDTH;
        CGFloat fScal = fVscal>fHscal?fVscal:fHscal;
        CGFloat fImageViewHeight = image.size.height/fScal;
        CGFloat fImageViewWidth = image.size.width/fScal;
        
        UIImageView * imageView = [_arrImageViews objectAtIndex:i];
        [imageView setImage:image];
        imageView.frame = CGRectMake(i*MAIN_WIDTH+MAIN_WIDTH/2-fImageViewWidth/2, MAIN_HEIGHT/2-fImageViewHeight/2, fImageViewWidth, fImageViewHeight);
        [_scrollView addSubview:imageView];
    }
    self.title = [NSString stringWithFormat:@"%zi/%zi",_nIndex + 1,_arrImages.count];
}

-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.scrollView.delegate = self;
    [self.view bringSubviewToFront:navigationBG];
    [title setText:[NSString stringWithFormat:@"%zi/%zi",_nIndex+1, _arrImages.count]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if (self.bShowDel) {
        [m_rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [m_rightBtn setFrame:CGRectMake(MAIN_WIDTH-70,27,70,30)];
        m_rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [m_rightBtn addTarget:self action:@selector(delImage) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    self.bShowNavigation = !self.bShowNavigation;
    if (self.bShowNavigation) {
        navigationBG.hidden = NO;
    }
    else{
        navigationBG.hidden = YES;
    }
}

-(void)delImage{
    [self.arrImages removeObjectAtIndex:_nIndex];
    if (_nIndex >= self.arrImages.count) {
        _nIndex = self.arrImages.count -1;
    }
    
    [self reloadImages];
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImage:)]) {
        [self.delegate deleteImage:_nIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showImage{
    UIImage* image = [_arrImages objectAtIndex:_nIndex];
    
    CGFloat fVscal = image.size.height/MAIN_HEIGHT;
    CGFloat fHscal = image.size.width/MAIN_WIDTH;
    CGFloat fScal = fVscal>fHscal?fVscal:fHscal;
    CGFloat fImageViewHeight = image.size.height/fScal;
    CGFloat fImageViewWidth = image.size.width/fScal;
    
    [self.imageView setFrame:CGRectMake(MAIN_WIDTH/2-fImageViewWidth/2, MAIN_HEIGHT/2-fImageViewHeight/2, fImageViewWidth, fImageViewHeight)];
    [self.imageView setImage:image];
    [title setText:[NSString stringWithFormat:@"%zi/%zi",_nIndex+1, _arrImages.count]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _nIndex = scrollView.contentOffset.x/scrollView.width;
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",_nIndex + 1,_arrImages.count];
}

@end
