//
//  HeaderWithOrientatedImage.m
//  CAGInTouch
//
//  Created by Thu Linn on 13/11/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "HeaderWithOrientatedImage.h"
#import "EGOImageView.h"
#import <AVFoundation/AVFoundation.h>
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"
#import "MWCaptionView.h"
#import "OrientatedImagePSTCollectionViewCell.h"

@interface HeaderWithOrientatedImage() < UIScrollViewDelegate,iCarouselDataSource, iCarouselDelegate, MWPhotoBrowserDelegate, PSTCollectionViewDataSource, PSTCollectionViewDelegate>

@property (strong, nonatomic) NSDictionary *mainData;
@property (strong, nonatomic) NSMutableArray *viewData;

@property (assign, nonatomic) NSInteger viewType;
@property (retain, nonatomic) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *imageContainerCollection;

@property (nonatomic, assign) BOOL hasCreatedForImageGallery;
@property (nonatomic, assign) NSInteger contentWidth;
@property (nonatomic, assign) NSInteger contentHeight;
@end

@implementation HeaderWithOrientatedImage

static NSString *cellIdentifier = @"OrientatedImagePSTCollectionViewCell";

#pragma mark - Implementations

- (void)awakeFromNib
{
    self.contentWidth = 260;
    self.contentHeight = 180;
    self.lineSpacing = 10;
    self.offsetXForCaption = 0;
    self.imageGalleryIdx = ImageGalleryCarousel; //As default
}

+ (HeaderWithOrientatedImage *)loadFromNib
{
    HeaderWithOrientatedImage *vw = [[[NSBundle mainBundle] loadNibNamed:@"HeaderWithOrientatedImage" owner:nil options:nil] lastObject];
    return vw;
}

- (void)layoutSubviews
{
    if (self.viewData.count != 1)
    {
        if (self.imageGalleryIdx == ImageGalleryCarousel)
        [self.imgContainer setX:-22]; //user won't be able to swipe from 22 pixel away from right side
    }
}

- (void)setType:(NSInteger)type
{
    self.viewType = type;
}

- (void)setData:(NSDictionary *)dict
{
    //Format to put into this dict
    
    /*
     files =     (
     {
     caption = "";
     "file_url" = "http://cag-intouch.s3.amazonaws.com/through_your_eyes/Gt8FNJOPTzRbXYOO0pCWoHQRc5KcTJP9hnRODuSh_file0.png";
     },
     {
     caption = "";
     "file_url" = "http://cag-intouch.s3.amazonaws.com/through_your_eyes/Wl9dkf6Hl5bCeDAIazyWcrwuDHEgtiqBW7d70crb_file1.png";
     }
     );
     */
    
    self.imageContainerCollection = [NSMutableArray array];
    self.photos = [NSMutableArray array];

    self.mainData = [NSDictionary dictionaryWithDictionary:dict];
    self.viewData = [NSMutableArray arrayWithArray:self.mainData[@"files"]];
    self.contentCount = self.viewData.count;
    
    if (self.viewData.count == 1)
    {
        self.contentWidth = CGRectGetWidth(self.frame);
        if (self.imageGalleryIdx == ImageGalleryCarousel)
            self.imgContainer.scrollEnabled = NO;
        else if (self.imageGalleryIdx == ImageGalleryCollection)
            self.gridView.scrollEnabled = NO;
    }
    
    if (self.imageGalleryIdx == ImageGalleryCarousel)
    {
        if (!self.hasCreatedForImageGallery)
        {
            self.hasCreatedForImageGallery = YES;
            self.imgContainer.type = iCarouselTypeLinear;
            self.imgContainer.delegate = self;
            self.imgContainer.dataSource = self;
            [self setUpCarousel:self.imgContainer];
        }
        [self.imgContainer reloadData];
    }
    else if (self.imageGalleryIdx == ImageGalleryCollection)
    {
        if (!self.hasCreatedForImageGallery)
        {
            self.hasCreatedForImageGallery = YES;
            [self createGridView];
        }
        [self.gridView reloadData];
    }
    
    for (NSDictionary *dic in self.viewData)
    {
        NSString *fileURL = dic[@"file_url"];
        NSArray *fileURLParts = [fileURL componentsSeparatedByString:@"?"];
        
        NSString *imageURL = fileURLParts[0];
        NSString *fileExt = imageURL.pathExtension;
        NSURL *photoURL;
        
        if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"])
        {
            photoURL = [NSURL URLWithString:dic[@"file_url"]];
        }
        else
        {
            photoURL = [NSURL URLWithString:dic[@"thumbnail_url"]];
        }
        
        NSString *captionStr = dic[@"caption"];
        MWPhoto* photo = [MWPhoto photoWithURL:photoURL];
        photo.caption = captionStr;
        [self.photos addObject: photo];
    }
}

-(void)setUpCarousel :(iCarousel *)carousel
{
    carousel.stopAtItemBoundary= YES;
    carousel.decelerationRate = 0.5;
    carousel.bounces = YES;
    carousel.scrollSpeed = 0.8f;
    carousel.contentView.userInteractionEnabled = YES;
}

- (void)makeNoGapOnTopAndBottomOfView //call this after gridview is created.
{
    //there will still be gap horizontally between each view/photo/item
    if (self.imageGalleryIdx == ImageGalleryCarousel)
    {
        [self setH:CGRectGetHeight(self.imgContainer.frame)];
        [self.imgContainer setY:0];
    }
    else if (self.imageGalleryIdx == ImageGalleryCollection)
    {
        [self setH:CGRectGetHeight(self.gridView.frame)];
        [self.gridView setY:0];
        self.contentHeight = CGRectGetHeight(self.gridView.frame);
    }
}

- (void)setUpHeightForView:(CGFloat )height  //call this after gridview is created.
{
    [self setH:height];
    if (self.imageGalleryIdx == ImageGalleryCarousel)
    {
        [self.imgContainer setH:height];
        [self.imgContainer setY:0];
    }
    else if (self.imageGalleryIdx == ImageGalleryCollection)
    {
        self.contentHeight = height;
        [self.gridView setH:height];
        [self.gridView setY:0];
    }
}

- (void)setUpWidthAndHeightForImageWithWidth:(CGFloat )width andHeight:(CGFloat )height
{
    //height of main view, content view will be modified.
    //width of content view will be modified
    self.contentWidth = width;
    [self setUpHeightForView:height];
}

- (void)galleryClicked:(NSInteger)tag
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:(tag)];
    browser.enableSwipeToDismiss = YES;
    UINavigationController *centerViewController = (UINavigationController *) self.window.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    [centerViewController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Grid View

- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = PSTCollectionViewScrollDirectionHorizontal;
    [layout setMinimumLineSpacing:self.lineSpacing];
    
    self.gridView = [[PSUICollectionView alloc] initWithFrame:CGRectMake(0,8 , CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.tag = 0;
    [self.gridView registerClass:[OrientatedImagePSTCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    [self addSubview:self.gridView];
}

#pragma mark - UIScrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.imageGalleryIdx == ImageGalleryCarousel) return;
    
    if ([self.delegate respondsToSelector:@selector(headerWithOrientatedImageBeginScrolling)])
    [self.delegate headerWithOrientatedImageBeginScrolling];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.imageGalleryIdx == ImageGalleryCarousel || self.disablePagingForCollectionView) return;
    
    // Determine the page index to fall on based on scroll position.
    CGFloat pageIndex = self.gridView.contentOffset.x / 270; //260 + 5 + 5
    
    // Going forward, we round to the next page.
    if( velocity.x > 0 ) {
        pageIndex = ceilf( pageIndex );
    }
    
    // Round to the closest page if we have no velocity.
    else if( velocity.x == 0 ) {
        pageIndex = roundf( pageIndex );
    }
    
    // Round to the previous page (odds are, we're going backwards).
    else {
        pageIndex = floorf( pageIndex );
    }
    
    // This is likely our new offset
    CGFloat newOffset = ( pageIndex * 270 );
    
    // If we don't have enough for a full page at the end, snap to the end point.
    // This means the penultimate page will have some content crossover with the
    // last page, and mirrors the default paging behaviour.
    if( newOffset > self.gridView.contentSize.width - 270 ) {
        newOffset = self.gridView.contentSize.width - 270;
    }
    
    // Set our target content offset.
    // We multiply the target page index by the page width, and adjust for the content inset.
    targetContentOffset->x = newOffset - self.gridView.contentInset.left;
    
    if ([self.delegate respondsToSelector:@selector(headerWithOrientatedImageEndScrolling)])
    [self.delegate headerWithOrientatedImageEndScrolling];
}


#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (carousel == self.imgContainer)
    {
        return self.viewData.count;
    }
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return 3;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    if (carousel == self.imgContainer)
    {
        NSDictionary *imgDict = self.viewData[index];
        
        UIView *vwImg = [carousel dequeueRecycledPage];
        if (!vwImg)
        {
           vwImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth,CGRectGetHeight(self.imgContainer.frame))];
            vwImg.clipsToBounds = YES;
            
            NSString *fileURL = imgDict[@"file_url"];
            NSArray *fileURLParts = [fileURL componentsSeparatedByString:@"?"];
            
            NSString *imageURL = fileURLParts[0];
            NSString *fileExt = imageURL.pathExtension;
            NSURL *photoURL;
            
            if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"])
            {
                photoURL = [NSURL URLWithString:imgDict[@"file_url"]];
            }
            else
            {
                photoURL = [NSURL URLWithString:imgDict[@"thumbnail_url"]];
            }
            
            EGOImageView *imgEgo = [[EGOImageView alloc]init];
            imgEgo.contentMode = UIViewContentModeScaleAspectFill;
            [imgEgo setImageURL:photoURL andAllowToView:NO andFaceRecognize:NO]; //Rules: due to face detecting, we need to set image url at last. after set, dun change width and height already.
            
            [imgEgo setTag:index];
            [imgEgo setFrame:vwImg.frame];
            [vwImg addSubview:imgEgo];
            
            NSString *captionStr = imgDict[@"caption"];
            
            if (captionStr.length > 0)
            {
                UILabel *lblCaption = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(vwImg.frame) - 20, self.contentWidth, 20)];
                lblCaption.backgroundColor = [UIColor colorWithWhite:0.05f alpha:0.5f];
                lblCaption.text = [NSString stringWithFormat:@"   %@",captionStr];
                lblCaption.textAlignment = UITextAlignmentLeft;
                lblCaption.textColor = [UIColor whiteColor];
                lblCaption.font = [UIFont systemFontOfSize:11.0f];
                [vwImg addSubview:lblCaption];
            }
            
            return vwImg;
        }
    }
    return [[UIView alloc] init];
}

#pragma mark - iCarouselDelegate

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [self galleryClicked:index];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.contentWidth + 8;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    [self.delegate headerWithOrientatedImageBeginScrolling];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [self.delegate headerWithOrientatedImageEndScrolling];
}

#pragma mark - PSTCollectionView Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrientatedImagePSTCollectionViewCell *cell = (OrientatedImagePSTCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    [cell setData:self.viewData[indexPath.row]];
    [cell.lblCaption setX:self.offsetXForCaption];
    
    if (self.rightAlignForCaption) [cell.lblCaption setTextAlignment:UITextAlignmentRight];
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.viewData count];
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)])
    {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
    else
    {
        [self galleryClicked:indexPath.row];
    }
}

#pragma mark - ScrollviewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDraggingOrDeacceleratingFromCollectionView:)])
    {
        [self.delegate scrollViewDidEndDraggingOrDeacceleratingFromCollectionView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDraggingOrDeacceleratingFromCollectionView:)])
    {
        [self.delegate scrollViewDidEndDraggingOrDeacceleratingFromCollectionView:scrollView];
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    
    MWPhoto *photo = [self.photos objectAtIndex:index];
    
    NSString *caption = self.viewData[index][@"caption"];
    if (caption.length > 0)
    {
        if ([photo respondsToSelector:@selector(caption)])
        {
            MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
            return captionView;
        }
    }
    return nil;
}

@end