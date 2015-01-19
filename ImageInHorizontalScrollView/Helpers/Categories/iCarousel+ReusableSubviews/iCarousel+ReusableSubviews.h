//
//  iCarousel+ReusableSubviews.h
//  CAGAppHd
//
//  Created by jeffry on 2012-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCarousel.h"

// instructions:
// in viewDidUnload, call clearRecycledPages
// in viewForItemAtIndex, do this:
//   UIView *page = [carousel dequeueRecycledPage];
//   if (!page) {
//       page = .... // create new page here
//       [carousel addNewPage:page];
//   }
//   return page;

@interface iCarousel (ReusableSubviews)

- (UIView *)dequeueRecycledPage;
- (void)addNewPage:(UIView *)page;
- (void)clearRecycledPages;

@end
