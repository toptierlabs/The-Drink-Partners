//
//  ImageSliderViewController.h
//  TDP
//
//  Created by TopTier on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageSliderViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIPageControl *pageControl; 
    IBOutlet UIScrollView *scroller; //Scroll view that contains the images
    
    NSArray * views;
    NSInteger currentPage;
}

@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic, retain) UIScrollView *scroller;
@property (nonatomic, retain) NSArray *views;



@property (nonatomic) NSInteger currentPage;

- (IBAction) clickPageControl:(id)sender;

@end
 