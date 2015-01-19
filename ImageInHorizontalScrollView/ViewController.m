//
//  ViewController.m
//  ImageInHorizontalScrollView
//
//  Created by Thu Linn on 19/1/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "ViewController.h"
#import "HeaderWithOrientatedImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblImg;
@property (strong, nonatomic) HeaderWithOrientatedImage *vwHeaderWithOrientatedImage;
@end

@implementation ViewController

- (void)awakeFromNib
{
    self.vwHeaderWithOrientatedImage = [HeaderWithOrientatedImage loadFromNib];
    self.vwHeaderWithOrientatedImage.imageGalleryIdx = ImageGalleryCollection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *firstImg = @{@"caption":@"First", @"file_url":@"http://www.vanityfair.com/politics/2012/12/burma-aung-san-suu-kyi/_jcr_content/par/cn_contentwell/par-main/cn_pagination_contai/cn_image.size.aung-san-suu-kyi.jpg"};
    NSDictionary *secondImg = @{@"caption":@"Second", @"file_url":@"http://cdn.yomadic.com/wp-content/uploads/2012/01/shwedagon-pagoda-night-myanmar-burma-yangon-rangoon-gold.jpg"};
    NSDictionary *thirdImg = @{@"caption":@"Third", @"file_url":@"http://www.amazingplacesonearth.com/wp-content/uploads/2012/10/Bagan-Myanmar-2.jpg"};
    NSDictionary *fouthImg = @{@"caption":@"Fouth", @"file_url":@"http://www.monkeyrockworld.com/blog/wp-content/uploads/2010/02/INLAY.jpg"};
    
    NSMutableArray *muArr = [NSMutableArray arrayWithObjects:firstImg,secondImg,thirdImg, fouthImg, nil];
    
    [self.vwHeaderWithOrientatedImage setData:@{@"files":muArr}];
    [self.vwHeaderWithOrientatedImage makeNoGapOnTopAndBottomOfView];
    [self.vwHeaderWithOrientatedImage setUpWidthAndHeightForImageWithWidth:120 andHeight:120];
    [self.vwHeaderWithOrientatedImage setY:CGRectGetMaxY(self.lblImg.frame) + 4];
    
    [self.view addSubview:self.vwHeaderWithOrientatedImage];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.vwHeaderWithOrientatedImage setW:CGRectGetWidth(self.view.frame)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
