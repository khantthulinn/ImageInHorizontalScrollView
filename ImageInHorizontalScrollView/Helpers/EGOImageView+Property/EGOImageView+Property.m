//
//  UIImageView+Property.m
//  CAGCitadel
//
//  Created by Thomas Tan on 21/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EGOImageView+Property.h"
#import <objc/runtime.h>

@implementation EGOImageView (Property)

static char UIB_PROPERTY_KEY, UIB_PROPERTY_URL;

@dynamic key, url;

- (void)setKey:(NSString *)key {
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)key {
    return (NSString *)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

- (void)setUrl:(NSString *)url {
    objc_setAssociatedObject(self, &UIB_PROPERTY_URL, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)url {
    return (NSString *)objc_getAssociatedObject(self, &UIB_PROPERTY_URL);
}

@end
