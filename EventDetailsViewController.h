//
//  EventDetailsViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageSliderViewController;

@interface EventDetailsViewController : UIViewController {
    NSArray *images;
    NSArray *imagesBig;
    NSString *text;
    
    IBOutlet UITextView *textView;
    UIButton *image1;
    UIButton *image2;
    UIButton *image3;
    UIButton *image4;
    UIButton *image5;
    NSInteger lastImagesSize;
    
    ImageSliderViewController *imageSliderController;
    
//    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *imagesBig;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIButton *image1;
@property (nonatomic, retain) UIButton *image2;
@property (nonatomic, retain) UIButton *image3;
@property (nonatomic, retain) UIButton *image4;
@property (nonatomic, retain) UIButton *image5;
@property (nonatomic) NSInteger lastImagesSize;
@property (nonatomic, retain)  ImageSliderViewController *imageSliderController;

//@property (nonatomic, retain) UIScrollView *scrollView;

-(IBAction) imgClicked:(id) sender;
-(void) resetInfo;

@end
