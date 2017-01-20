//
//  InfoCollectionSectionHeader.h
//  anhui
//
//  Created by yangjuanping on 16/3/11.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoCollectionSectionHeaderDelegate <NSObject>
-(void)didSelectSectionRightBtnAtSection:(NSInteger)section;
@end

@interface InfoCollectionSectionHeader : UICollectionReusableView
-(void)setTitle:(NSString*)strTitle Param:(NSString*)strParam;
@property(nonatomic,assign) id<InfoCollectionSectionHeaderDelegate> delegate;
@end
