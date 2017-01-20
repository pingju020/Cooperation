//
//  ImageCollectionView.m
//  anhui
//
//  Created by yangjuanping on 16/9/20.
//  Copyright © 2016年 Education. All rights reserved.
//

#import "ImageCollectionView.h"
#import "ImageCollectionViewCell.h"
#import "ELCImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage-Extensions.h"
#import "BigImageViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

static const CGFloat kItemVSpace = 10;
static const CGFloat kItemHSpace = 10;
#define TailoringCoefficient 3.0

@interface ImageCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate,ELCImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,BigImageViewControllerDelegate>
@property(nonatomic,strong)UICollectionView* collection;
@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)CGFloat viewWidth;
@property(nonatomic,strong)NSMutableArray* arrImage;
@property(nonatomic,strong)NSMutableArray* arrImageScal;
@property(nonatomic,assign)BOOL bShowAddButton;
@property(nonatomic,assign)NSInteger nImageNum;
@property(nonatomic,assign)NSInteger nColumnNum;
@property(nonatomic,assign)CGFloat   fViewHeight;
@property(nonatomic,strong)UIViewController* vcParent;
@end


@implementation ImageCollectionView

-(id)initWithFrame:(CGRect)frame withVC:(UIViewController*)vc{
    if (self = [super initWithFrame:frame]) {
        _vcParent = vc;
        _viewWidth = frame.size.width;
        _arrImage = [[NSMutableArray alloc]init];
        _bShowAddButton = YES;
        _nImageNum = 9;
        //_collection每行排布cell数，默认3，每个cell之间以及第一个cell左侧，最后一个cell右侧空出来的区域为20
        _nColumnNum = 3;
        
    }
    return self;
}

- (void)reloadData {
    [self.collection setHeight:_fViewHeight];
    NSInteger nImageNum = (_bShowAddButton && _arrImage.count < _nImageNum)?_arrImage.count+1:_arrImage.count;
    NSInteger nRowNum = ((nImageNum%_nColumnNum)>0?1:0)+(nImageNum/_nColumnNum);
    _fViewHeight = nRowNum*_cellSize.height + nRowNum*kItemVSpace + kItemVSpace;
    [self setHeight:_fViewHeight];
    [self.collection setHeight:_fViewHeight];
    [self.collection reloadData];
    if (self.delegate) {
        [self.delegate reloadData:self.arrImage viewHeight:_fViewHeight];
    }
}

-(CGFloat)getInfoCollectionViewHeight{
    return 10;
}


-(void)addImages{
    UIActionSheet* menu = nil;
    menu = [[UIActionSheet alloc]
            initWithTitle:nil
            delegate:self
            cancelButtonTitle:@"取消"
            destructiveButtonTitle:nil
            otherButtonTitles:@"相册", @"拍照", nil];
    menu.tag = 1;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self];
}

-(NSArray*)getImages{
    return self.arrImage;
}

-(void)setDelegate:(id<ImageCollectionViewDelegate>)delegate{
    _delegate = delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(showAddButtonInView:)]) {
        _bShowAddButton = [_delegate showAddButtonInView:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(maxNumOfImagesInView:)]) {
        _nImageNum = [_delegate maxNumOfImagesInView:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(columnOfImagesInView:)]) {
        _nColumnNum = [_delegate columnOfImagesInView:self];
    }
    CGFloat cellWidth = (_viewWidth-kItemHSpace*_nColumnNum-kItemHSpace)/_nColumnNum;
    _cellSize = CGSizeMake(cellWidth, cellWidth*0.75);
}

-(UICollectionView*)collection{
    if (_collection == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 10) collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.bounces = NO;
        _collection.pagingEnabled = YES;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.delaysContentTouches = NO;
        _collection.canCancelContentTouches = YES;
        _collection.scrollEnabled = NO;
        [_collection registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
        [self addSubview:_collection];
    }
    return _collection;
}

//相册选图片
-(void) pickImage
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = _nImageNum; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [_vcParent presentViewController:elcPicker animated:YES completion:nil];
    
}

- (void)snapImage
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有拍照功能" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    UIImagePickerController  *eImagePickerController = [[UIImagePickerController alloc] init];
    eImagePickerController.delegate=self;
    
    
    eImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    eImagePickerController.allowsEditing = YES;
    //    eImagePickerController.cameraDevice = UIImagePickerControllerSourceTypeCamera;
    eImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    eImagePickerController.showsCameraControls = YES;
    eImagePickerController.navigationBarHidden = NO;
    eImagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    //eImagePickerController.wantsFullScreenLayout = NO;
    
    [_vcParent presentViewController:eImagePickerController animated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_bShowAddButton && _arrImage.count < _nImageNum) {
        return _arrImage.count+1;
    }
    return _arrImage.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _cellSize;
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kItemVSpace, kItemHSpace, kItemVSpace, kItemHSpace);//上 左 下 右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"ImageCollectionViewCell";
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    if (indexPath.row < (NSInteger)_arrImage.count) {
        [cell createCell:[_arrImage objectAtIndex:indexPath.row] withSize:_cellSize];
    }
    else{
        [cell createCell:[UIImage imageNamed:@"Add_Photo_Image_Addition"] withSize:_cellSize];
    }
    
    return cell;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@",indexPath);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击查看大图
    if (indexPath.row < (NSInteger)_arrImage.count) {
//        UIActionSheet* menu = nil;
//        menu = [[UIActionSheet alloc]
//                initWithTitle:nil
//                delegate:self
//                cancelButtonTitle:@"取消"
//                destructiveButtonTitle:nil
//                otherButtonTitles:@"删除", nil];
//        menu.tag = 2;
//        menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//        [menu showInView:self];
        BigImageViewController* vc = [[BigImageViewController alloc]initWithImages:_arrImage showIndex:indexPath.row showDel:YES];
        vc.delegate = self;
        [_vcParent.navigationController pushViewController:vc animated:YES];
    }
    
    // 添加图片
    else{
        [self addImages];
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self pickImage];
                break;
            case 1:
                [self snapImage];
                break;
                
            default:
                break;
        }
    }
    else{
        NSLog(@"buttonIndex = %zi", buttonIndex);
    }
}

#pragma mark -- ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    SETSTATESTYTLELIGHT
    NSInteger imageArrNumber ;
    imageArrNumber = self.arrImage.count;
    if (imageArrNumber + info.count > self.nImageNum) {
        if (IsArrEmpty(info)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多选择%zi张图片",self.nImageNum] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [_vcParent dismissViewControllerAnimated:YES completion:nil];
    
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    NSMutableArray *imagesBig = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage *imageSmall = [self imageAccordingTOAspectRatioCut:_cellSize.height width:_cellSize.width resolution:TailoringCoefficient imageOriginal:image];
                [images addObject:image];
                [imagesBig addObject:image];
            } else {
                SpeLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSData *imagedata =  [self imageCompression:image compressionProportion:1];
                image = [UIImage imageWithData:imagedata];
                //                [self imageCompression:image compressionProportion:0.8f];
                
                [images addObject:image];
            } else {
                SpeLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            SpeLog(@"Uknown asset type");
        }
    }
    [self.arrImageScal addObjectsFromArray:images];
    [self.arrImage addObjectsFromArray:imagesBig];
    [self reloadData];
}

//根据宽高比裁剪
- (UIImage *)imageAccordingTOAspectRatioCut:(float)imageHeight width:(float)imageWidth resolution:(float)coefficient imageOriginal:(UIImage *)imageOriginal {
    UIImage *imageSmall = [UIImage imageWithImage:imageOriginal scaledToSizeWithSameAspectRatio:CGSizeMake(imageWidth*coefficient, imageHeight*coefficient)];
    return imageSmall;
}

- (NSData *)imageCompression:(UIImage *)image compressionProportion:(CGFloat)proportion{
    float kCompressionQuality = proportion;
    
    //    NSData *imgData1 = UIImageJPEGRepresentation(image, kCompressionQuality);
    //    SpeLog(@"1.0 size: %ld", (unsigned long)imgData1.length);
    
    //    NSData *imgData2 = UIImageJPEGRepresentation(image, 0.7f);
    //    SpeLog(@"0.7 size: %ld", (unsigned long)imgData2.length);
    //
    //    NSData *imgData3 = UIImageJPEGRepresentation(image, 0.4f);
    //    SpeLog(@"0.4 size: %ld", (unsigned long)imgData3.length);
    //
    //
    //    NSData *imgData4 = UIImageJPEGRepresentation(image, 0.0f);
    //    SpeLog(@"0.0 size: %ld", (unsigned long)imgData4.length);
    NSData *photoData = UIImageJPEGRepresentation(image, kCompressionQuality);
    //    SpeLog(@"%ld",(unsigned long)photoData.length);
    //    if (photoData.length > 200.0*1024) {
    //        UIImage *imageAgain = [UIImage imageWithData:photoData];
    //        photoData = [self imageCompression:imageAgain compressionProportion:0.6f];
    //    }
    return photoData;
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    SETSTATESTYTLELIGHT
    [_vcParent dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerControllerDelegate
//取消拍照照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    SETSTATESTYTLELIGHT
    [_vcParent dismissViewControllerAnimated:YES completion:nil];
}

//选择拍照照片
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    SETSTATESTYTLELIGHT
    [_vcParent dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imagedata =  [self imageCompression:image compressionProportion:1];
    image = [UIImage imageWithData:imagedata];
    
    [self.arrImageScal addObject:image];
    [self.arrImage addObject:image];
    [self reloadData];
}


#pragma mark -- BigImageViewControllerDelegate
-(void)deleteImage:(NSInteger)index{
//    if (index < self.arrImage.count) {
//        [self.arrImage removeObjectAtIndex:index];
//    }
    [self reloadData];
}
@end
