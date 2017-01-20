//
//  MainViewController.m
//  Cooperation
//
//  Created by yangjuanping on 16/10/25.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "MainViewController.h"
#import "PJTabBarItem.h"
#import "HongbaoFloatView.h"
#import "CycleScrollView.h"
#import "HttpLoginAndRegister.h"
#import "MainDataModel.h"
#import "MainHomeItemLoadContext.h"

@interface MainViewController ()<CycleScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *scrbk;
@property(nonatomic, strong)CycleScrollView *scrPageView;
@end



@implementation MainViewController

#pragma mark -- 控件初始化
-(UIScrollView*)scrbk{
    if (_scrbk == nil) {
        _scrbk = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame)-40)];
        _scrbk.scrollEnabled = YES;
        [self.view addSubview:_scrbk];
    }
    return _scrbk;
}


-(CycleScrollView*)scrPageView{
    if (!_scrPageView) {
        // 图360*159
        _scrPageView = [[CycleScrollView alloc]initWithFrame:
                        CGRectMake(0, 0, MAIN_WIDTH, MAIN_WIDTH/360*159)];
        _scrPageView.delegate = self;
        [self.scrbk addSubview:_scrPageView];
    }
    
    return _scrPageView;
}

#pragma mark -- 获取数据
-(void)getRollAds{
    [LOGIN_REGISTER getRollAds:role==E_ROLE_TEACHER?@"2":@"5" successBlock:^(NSDictionary *succeedResult, BOOL isSucceed) {
        if (isSucceed && [[MainDataModel sharedInstance]parseRollAds:succeedResult]) {
            [self.scrPageView setImageUrlNames:[MainDataModel sharedInstance].arrImgList animationDuration:2];
        }

    } failedBolck:^(AFHTTPSessionManager *session, NSError *error) {
        
    }];
//    [NETWOTK_MANAGER getRollAds:[LoginUserUtil isTeacher] ? @"2" : @"5"
//                   successBlock:^(NSDictionary *retDic){
//                       BOOL isSuccess = IS_REQUEST_SUCCEED(retDic);
//                       if (isSuccess &&
//                           [[MainDataModel sharedInstance]parseRollAds:retDic]) {
//                           [self.scrPageView setImageUrlNames:[MainDataModel sharedInstance].arrImgList animationDuration:2];
//                       }
//                   }
//                    failedBolck:^(AFHTTPRequestOperation *response, NSError *error){
//                        
//                    }];
}


AH_BASESUBVCFORMAINTAB_MODULE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    [self getRollAds];
    [self.scrPageView setTop:0];
    
    CGFloat hHeight = CGRectGetHeight(self.scrPageView.frame);
    NSInteger itemCount = [[MainHomeItemLoadContext sharedInstance] getItemsCount];
    for (NSInteger index = 0; index<itemCount; index++) {
        UIView* itemView = [[MainHomeItemLoadContext sharedInstance]itemAtIndex:index];
    
        if (itemView) {
            [self.scrbk addSubview:itemView];
            CGFloat itemHeight = [[MainHomeItemLoadContext sharedInstance]itemHeightAtIndex:index];
            itemView.frame = CGRectMake(0, hHeight+10, MAIN_WIDTH, itemHeight);
            hHeight += itemHeight+10;
            [self.scrbk setContentSize:CGSizeMake(MAIN_WIDTH, hHeight)];
        }
    }
//    HongbaoFloatView* view = [[[NSBundle mainBundle]loadNibNamed:@"HongbaoFloatView" owner:self options:nil]lastObject];
//    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PJTabBarItem*)getTabBarItem{
    //
    PJTabBarItem* itemMainHome = [[PJTabBarItem alloc]init];
    itemMainHome.strTitle = @"主页";
    itemMainHome.strNormalImg = @"";
    itemMainHome.strSelectImg = @"";
    itemMainHome.viewController = self;
    itemMainHome.tabIndex = 1;
    //title.text = itemMainHome.strTitle;
    [self setTitle:itemMainHome.strTitle];
    return itemMainHome;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- CycleScrollViewDelegate
- (void)cycleScrollView:(CycleScrollView *)cycleScrollView DidTapImageView:(NSInteger)index{
    ;
}
- (void)cycleScrollview:(CycleScrollView *)cycleScrowllView ValueChanged:(NSInteger)
index{
    ;
}

@end
