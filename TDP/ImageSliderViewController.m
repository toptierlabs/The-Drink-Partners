//
//  ImageSliderViewController.m
//  TDP
//
//  Created by TopTier on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSliderViewController.h"
#import "TDPAppDelegate.h"

@implementation ImageSliderViewController

@synthesize pageControl, scroller;
@synthesize views, currentPage;



//Events
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    pageControl.currentPage = page;
    self.currentPage = page;
}

- (IBAction) clickPageControl:(id)sender {
    int page = pageControl.currentPage;
    
    CGRect frame = scroller.frame;
    frame.origin.x = frame.size.width *page;
    frame.origin.y = 0;
    
    self.currentPage = page;
    [scroller scrollRectToVisible:frame animated:YES];
    
}

//End Events


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidAppear:(BOOL)animated {
    int i = 1;
    for (UIView *view in views)
    {
        UIImageView *image = [[UIImageView alloc] initWithImage: (UIImage *) view];
        image.frame = CGRectMake((i-1) * 320, 0, 320, 367);
        [scroller addSubview: image];
        [image release];
        i++;
    }
    
    scroller.delegate = self;
    scroller.contentSize = CGSizeMake(320 * ([views count]), 367);
    scroller.pagingEnabled = TRUE;
    
    pageControl.numberOfPages = [views count];
    pageControl.currentPage = self.currentPage;
    
    CGRect frame = scroller.frame;
    frame.origin.x = frame.size.width * self.currentPage;
    frame.origin.y = 0;
    [scroller scrollRectToVisible:frame animated:NO];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    for (UIView *aView in [scroller subviews]){
        [aView removeFromSuperview];
    }

}


@end
