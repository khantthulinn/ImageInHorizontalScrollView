//
//  EGOImageView.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOImageView.h"
#import "EGOImageLoader.h"
#import "MWPhotoBrowser.h"
#import "Appdelegate.h"


@interface EGOImageView() <MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property(nonatomic,assign) BOOL allowToView;

@property (retain, nonatomic) NSMutableArray *photos;

@end
@implementation EGOImageView
@synthesize imageURL, placeholderImage, delegate;

- (id)initWithPlaceholderImage:(UIImage*)anImage {
    return [self initWithPlaceholderImage:anImage delegate:nil];
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate {
    if((self = [super initWithImage:anImage])) {
        self.placeholderImage = anImage;
        self.delegate = aDelegate;
    }
    return self;
}

- (void)setImageURL:(NSURL *)aURL andAllowToView:(BOOL)allowToView andFaceRecognize:(BOOL)faceRecognize
{
    self.allowToView = allowToView;
    
    self.photos = [NSMutableArray array];
    MWPhoto* photo = [MWPhoto photoWithURL:aURL];
    [self.photos addObject: photo];
    
    if (self.allowToView || self.callback)
    {
        self.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:self.frame];
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    
    if(self.imageURL)
    {
        NSArray *originalArr = [self.imageURL.absoluteString componentsSeparatedByString:@"?"];
        NSArray *newArr = [aURL.absoluteString componentsSeparatedByString:@"?"];
        
        if ([self.imageURL.absoluteString isEqualToString:aURL.absoluteString])
        {
            //            [self loadImageFromFaceDetectionSavingWithImage:nil andURL:aURL];//we are loading from saved directory and so we put nil..
            
            return;//we won't change anything again.
        }
        
        if (originalArr.count > 0 && newArr.count > 0)
        {
            if ([originalArr[0] isEqualToString:newArr[0]])
            {
                return; //we won't change anything again. //
            }
        }
        //		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
        //		[imageURL release];
        //		imageURL = nil;
    }
    else
    {
    
    }
    
    if(!aURL)
    {
        //		self.image = self.placeholderImage;
        //		imageURL = nil;
        return;
    } else {
        self.imageURL = [aURL retain];
    }
    
    if (!self.activityIndicator)
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc]init];
        if (CGRectGetWidth(self.frame) < 30)
        {
            [self.activityIndicator setW:CGRectGetWidth(self.frame) andH:CGRectGetHeight(self.frame)];
        }
        
        else  [self.activityIndicator setW:30 andH:30];
        
        //        self.activityIndicator.center = self.center;
        [self.activityIndicator setX:CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.activityIndicator.frame)/2 andY:CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.activityIndicator.frame)/2];
        
        //        [self.activityIndicator setBackgroundColor:[UIColor lightGrayColor]];
        [self.activityIndicator setColor:[UIColor lightGrayColor]];
        [self.activityIndicator startAnimating];
        
        if (CGRectGetWidth(self.frame) > 50)
            [self addSubview:self.activityIndicator];
        [self sendSubviewToBack:self.activityIndicator];
    }
    
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
    UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
    
    if(anImage)
    {
        self.image = anImage;
        
        if (self.imageModeIdx == imageModeAspectFit)
        {
            self.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            self.contentMode = UIViewContentModeScaleAspectFill;
        }

        
        self.clipsToBounds = YES;
        [self.activityIndicator stopAnimating];
        
        
    } else {
        self.image = self.placeholderImage;
    }
}

- (void)tap:(id)sender
{
    if (self.allowToView)
    {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [browser setCurrentPhotoIndex:(0)];//only 1 image
        browser.enableSwipeToDismiss = YES;
        UINavigationController *centerViewController = (UINavigationController *) self.window.rootViewController;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
        [centerViewController presentViewController:nav animated:YES completion:nil];
    }
    else if (self.callback)
    {
        self.callback();
    }
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
    [[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
    [[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification
{
    if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
    
    UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
    self.image = anImage;
    
    
    [self setNeedsDisplay];

    if (self.imageModeIdx == imageModeAspectFit)
    {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
    }

    self.clipsToBounds = YES;
    [self.activityIndicator stopAnimating];
    
    if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
        [self.delegate imageViewLoadedImage:self];
    }
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
    if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
    
    if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
        [self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
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

#pragma mark -
- (void)dealloc {
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
    self.imageURL = nil;
    self.placeholderImage = nil;
    [super dealloc];
}

@end
