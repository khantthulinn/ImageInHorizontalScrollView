# ImageInHorizontalScrollView
### Description

Allow to show images from web in horizontal scrollview using EgoImageView and tap on image to show full screen image. 

### Usuage 

![Usuage icon](http://i61.tinypic.com/35iorag.png)

<br>
<Code> #import "HeaderWithOrientatedImage.h" </Code>

<br>**Set up data**

<Code>
    NSDictionary *firstImg = @{@"caption":@"First", @"file_url":@"http://www.vanityfair.com/politics/2012/12/burma-aung-san-suu-kyi/_jcr_content/par/cn_contentwell/par-main/cn_pagination_contai/cn_image.size.aung-san-suu-kyi.jpg"};  </Code> 

<Code>
NSMutableArray *muArr = [NSMutableArray arrayWithObjects:firstImg,secondImg,thirdImg, fouthImg, nil]; </Code>

<br>**Set up HeaderWithOrientatedImage** <br>

<Code>
    self.vwHeaderWithOrientatedImage = [HeaderWithOrientatedImage loadFromNib];
    self.vwHeaderWithOrientatedImage.imageGalleryIdx = ImageGalleryCollection;
</Code>

<br>**Input data into HeaderWithOrientatedImage** 

<Code> [self.vwHeaderWithOrientatedImage setData:@{@"files":muArr}]; </br>
 </Code> 

**Add as subview**

<Code>
    [self.view addSubview:self.vwHeaderWithOrientatedImage]
;
 </Code>

### Acknowledgement 

**EgoImageView**, **MBProgressHUD**, **MWPhotoBrowser**, **PSTCollection**, **iCarousel** , **CBFrameHelpers**



