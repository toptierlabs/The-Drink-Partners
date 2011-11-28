//
//  ImageSliderViewController.m
//  TDP
//
//  Created by TopTier on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSliderViewController.h"
#import "TDPAppDelegate.h"
#import "asyncimageview.h"

@implementation ImageSliderViewController

@synthesize pageControl, scroller;
@synthesize views, currentPage;


//Events
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //Update page control page based on scroll view position
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    pageControl.currentPage = page;
    self.currentPage = page;
}

//Clicking on page control event
- (IBAction) clickPageControl:(id)sender {
    int page = pageControl.currentPage;
    
    //Set frame position
    CGRect frame = scroller.frame;
    frame.origin.x = frame.size.width *page;
    frame.origin.y = 0;
    
    //Set current page
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
    [views release];
    [pageControl release];
    [scroller release];
    
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
    self.pageControl = nil;
    self.scroller = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidAppear:(BOOL)animated {
    int i = 1;
    
    //Add images to scroll view
    for (NSURL *url in views)
    {
//        UIImageView *image = [[UIImageView alloc] initWithImage: (UIImage *) view];
//        image.frame = CGRectMake((i-1) * 320, 0, 320, 367);
//        [scroller addSubview: image];
//        [image release];
         
        CGRect frame = CGRectMake((i-1) * 320, 0, 320, 367);
        AsyncImageView *asyncImageBig = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];;
        [asyncImageBig loadImageFromURL:url];
        
         [scroller addSubview: asyncImageBig];
        
        i++;
    }
    
    scroller.delegate = self;
    scroller.contentSize = CGSizeMake(320 * ([views count]), 367);
    scroller.pagingEnabled = TRUE;
    
    //Refresh number of pages
    pageControl.numberOfPages = [views count];
    pageControl.currentPage = self.currentPage;
    
    //Set position
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
