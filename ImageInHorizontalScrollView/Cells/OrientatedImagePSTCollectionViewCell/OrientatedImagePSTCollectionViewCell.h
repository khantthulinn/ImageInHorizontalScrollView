//
//  OrientatedImagePSTCollectionViewCell.h
//  CAGInTouch
//
//  Created by Thu Linn on 17/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"

@interface OrientatedImagePSTCollectionViewCell : PSUICollectionViewCell
@property (strong, nonatomic) UILabel *lblCaption;
- (void)setData:(NSDictionary *)dict;

@end
