//
//  HeaderWithOrientatedImage.h
//  CAGInTouch
//
//  Created by Thu Linn on 13/11/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel+ReusableSubviews.h"
#import "PSTCollectionView.h"

typedef enum ImageGalleryType{
    ImageGalleryCollection,
    ImageGalleryCarousel
}ImageGalleryType;

@protocol HeaderWithOrientatedImageDelegate <NSObject>
@optional
- (void)headerWithOrientatedImageBeginScrolling;
- (void)headerWithOrientatedImageEndScrolling;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidEndDraggingOrDeacceleratingFromCollectionView:(UIScrollView *)scrollview;
@end

@interface HeaderWithOrientatedImage : UIView

@property (assign, nonatomic) id<HeaderWithOrientatedImageDelegate> delegate;

//Collection view
@property (nonatomic, strong) PSUICollectionView *gridView;

@property (nonatomic, assign) NSInteger contentCount;
@property (weak, nonatomic) IBOutlet iCarousel *imgContainer;
@property (assign, nonatomic) NSInteger imageGalleryIdx;
@property (nonatomic, assign) NSInteger lineSpacing; //if we want to overwrite value of this, call this b4 setData.. lineSpacing = horizontal gap between images

@property (nonatomic, assign) BOOL disablePagingForCollectionView;
@property (nonatomic, assign) CGFloat offsetXForCaption;
@property (nonatomic, assign) BOOL rightAlignForCaption;

+ (HeaderWithOrientatedImage *)loadFromNib;
- (void)setData:(NSDictionary *)dict;
- (void)setType:(NSInteger)type;
- (void)makeNoGapOnTopAndBottomOfView; //To call after setData
- (void)setUpWidthAndHeightForImageWithWidth:(CGFloat )width andHeight:(CGFloat )height; //To call after setData
- (void)setUpHeightForView:(CGFloat )height; //To call after setData
@end
