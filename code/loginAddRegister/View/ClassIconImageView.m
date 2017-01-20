//
//  ClassIconImageView.m
//  Cooperation
//
//  Created by yangjuanping on 16/11/17.
//  Copyright © 2016年 yangjuanping. All rights reserved.
//

#import "ClassIconImageView.h"
#import "UIImageView+WebCache.h"

@interface ClassIconImageView()
@end

@implementation ClassIconImageView

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (frame.size.height <= frame.size.width) {
        self.layer.cornerRadius = frame.size.height/2;
        self.clipsToBounds = YES;
    }
    else{
        self.layer.cornerRadius = frame.size.width/2;
        self.clipsToBounds = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setNewImage:(NSString*)Url WithSpeWith:(NSInteger)spe withDefaultImg:(NSString*)defaultImg{
    [self sd_setImageWithURL:[NSURL URLWithString:Url] placeholderImage:[UIImage imageNamed:defaultImg]];
}
@end
