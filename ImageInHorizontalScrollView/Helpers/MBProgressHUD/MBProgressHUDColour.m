//
//  MBProgressHUD+Colour.m
//  CAGAppHd
//
//  Created by jeffry on 2012-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBProgressHUDColour.h"

@implementation MBProgressHUDColour

- (void)fillRoundedRect:(CGRect)rect inContext:(CGContextRef)context {
    float radius = 10.0f;
	
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:130.0/255 green:42.0/255 blue:133.0/255 alpha:0.8].CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end
