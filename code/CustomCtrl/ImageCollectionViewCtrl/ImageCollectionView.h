//
//  ImageCollectionView.h
//  anhui
//
//  Created by yangjuanping on 16/9/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCollectionView;

@protocol ImageCollectionViewDelegate <NSObject>
@optional
-(NSInteger)maxNumOfImagesInView:(ImageCollectionView*)imageCollectionView;
-(NSInteger)columnOfImagesInView:(ImageCollectionView*)imageCollectionView;
-(BOOL)showAddButtonInView:(ImageCollectionView*)imageCollectionView;
@required
-(void)reloadData:(NSMutableArray*)arrImages viewHeight:(CGFloat)fHeight;
@end

@interface ImageCollectionView : UIView
@property(nonatomic,assign) id<ImageCollectionViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame withVC:(UIViewController*)vc;
-(void)addImages;
-(NSArray*)getImages;
@end
