//
//  ImageCollectionViewCell.m
//  anhui
//
//  Created by yangjuanping on 16/9/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation ImageCollectionViewCell

-(void)createCell:(UIImage*)image withSize:(CGSize)size{
//    CGFloat fVscal = image.size.height/size.height;
//    CGFloat fHscal = image.size.width/size.width;
//    CGFloat fScal = fVscal>fHscal?fVscal:fHscal;
//    CGFloat fImageViewHeight = image.size.height/fScal;
//    CGFloat fImageViewWidth = image.size.width/fScal;
//    
//    [self.imageView setFrame:CGRectMake(size.width/2-fImageViewWidth/2, size.height/2-fImageViewHeight/2, fImageViewWidth, fImageViewHeight)];
    [self.imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.imageView setImage:image];
}

-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
@end
