//
//  ImageSliderViewController.h
//  TDP
//
//  Created by TopTier on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageSliderViewController : UIViewController <UIScrollViewDelegate> {
    NSArray * views;
    NSInteger currentPage;
    
    UIPageControl *pageControl;
    UIScrollView *scroller;

}

@property (nonatomic, retain)  NSArray *views;
@property (nonatomic, retain) IBOutlet UIPageControl * pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;


@property (nonatomic) NSInteger currentPage;

- (IBAction) clickPageControl:(id)sender;
//- (void) animateToView:(UIView *)newView;
//- (void) animateToViewByPosition:(NSInteger)position;

@end
