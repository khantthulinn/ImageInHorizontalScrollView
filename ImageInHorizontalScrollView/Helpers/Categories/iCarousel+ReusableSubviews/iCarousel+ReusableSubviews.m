//
//  iCarousel+ReusableSubviews.m
//  CAGAppHd
//
//  Created by jeffry on 2012-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCarousel+ReusableSubviews.h"
#import <objc/runtime.h>

static char const * const TAG_ICAR_RECYCLEDPAGES = "recycledPages";
static char const * const TAG_ICAR_VISIBLEPAGES = "visiblePages";

@implementation iCarousel (ReusableSubviews)

// http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/

#pragma mark - Properties

- (NSMutableSet *)recycledPages {
    id obj = objc_getAssociatedObject(self, TAG_ICAR_RECYCLEDPAGES);
    if (obj) return obj;
    obj = [[[NSMutableSet alloc] init] autorelease];
    [self setRecycledPages:obj];
    return obj;
}

- (void)setRecycledPages:(NSMutableSet *)obj {
    objc_setAssociatedObject(self, TAG_ICAR_RECYCLEDPAGES, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet *)visiblePages {
    id obj = objc_getAssociatedObject(self, TAG_ICAR_VISIBLEPAGES);
    if (obj) return obj;
    obj = [[[NSMutableSet alloc] init] autorelease];
    [self setVisiblePages:obj];
    return obj;
}

- (void)setVisiblePages:(NSMutableSet *)obj {
    objc_setAssociatedObject(self, TAG_ICAR_VISIBLEPAGES, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Methods

- (UIView *)dequeueRecycledPage {
    // Recycle no-longer-visible pages 
    for (UIView *page in [self visiblePages]) {
        if (![[self visibleItemViews] containsObject:page]) {
            [[self recycledPages] addObject:page];
            [page removeFromSuperview];
        }
    }
    [[self visiblePages] minusSet:[self recycledPages]];
    
    UIView *page = [[self recycledPages] anyObject];
    if (page) {
        [[page retain] autorelease];
        [[self recycledPages] removeObject:page];
        [[self visiblePages] addObject:page];
    }
    return page;
}

- (void)addNewPage:(UIView *)page {
    [[self visiblePages] addObject:page];
}

- (void)clearRecycledPages {
    [self setRecycledPages:nil];
}

@end
