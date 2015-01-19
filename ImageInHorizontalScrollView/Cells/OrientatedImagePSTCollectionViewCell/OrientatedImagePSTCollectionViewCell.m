//
//  OrientatedImagePSTCollectionViewCell.m
//  CAGInTouch
//
//  Created by Thu Linn on 17/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "OrientatedImagePSTCollectionViewCell.h"
#import "EGOImageView.h"
@interface OrientatedImagePSTCollectionViewCell()
@property (strong, nonatomic) EGOImageView *imgEgo;
@property (strong, nonatomic) UIView *vwCaptionContainer;
@property (strong, nonatomic) NSDictionary *mainData;
@end

@implementation OrientatedImagePSTCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = background;
        self.backgroundColor = [UIColor whiteColor];
        
        //EgoImageView
        self.imgEgo = [[EGOImageView alloc]init];
        self.imgEgo.contentMode = UIViewContentModeScaleAspectFill;
        [self.imgEgo setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        //Caption Container
        self.vwCaptionContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 20, CGRectGetWidth(self.frame), 20)];
        [self.vwCaptionContainer setBackgroundColor:[UIColor colorWithWhite:0.05f alpha:0.5f]];

        //Caption
        self.lblCaption = [[UILabel alloc] init];
        [self.lblCaption setW:CGRectGetWidth(self.contentView.frame) andH:20];
        [self.lblCaption setX:0 andY:0];
        self.lblCaption.backgroundColor = [UIColor clearColor];
        [self.vwCaptionContainer addSubview:self.lblCaption];
        self.lblCaption.textAlignment = UITextAlignmentLeft;
        self.lblCaption.textColor = [UIColor whiteColor];
        
        //Add subview
        [self.contentView addSubview:self.imgEgo];
        [self.contentView addSubview:self.vwCaptionContainer];
        

        //Set font
        [self setFont];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imgEgo.clipsToBounds = YES;
}

#pragma mark - Implementations
- (void)setData:(NSDictionary *)dict
{
    self.mainData = [NSDictionary dictionaryWithDictionary:dict];
    
    NSString *fileURL = self.mainData[@"file_url"];
    NSArray *fileURLParts = [fileURL componentsSeparatedByString:@"?"];
    
    NSString *imageURL = fileURLParts[0];
    NSString *fileExt = imageURL.pathExtension;
    NSURL *photoURL;
    
    if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"jpg"])
        photoURL = [NSURL URLWithString:self.mainData[@"file_url"]];
    
    else
        photoURL = [NSURL URLWithString:self.mainData[@"thumbnail_url"]];
    
    [self.imgEgo setImageURL:photoURL andAllowToView:NO andFaceRecognize:NO];

    NSString *captionStr = self.mainData[@"caption"];
    
    if (captionStr.length > 0)
    {
        [self.lblCaption setText:[NSString stringWithFormat:@"%@",captionStr]];
    }
    else
    {
        [self.vwCaptionContainer setHidden:YES];
    }
    
}

- (void)setFont
{
    self.lblCaption.font = [UIFont systemFontOfSize:12.0f];
}

@end