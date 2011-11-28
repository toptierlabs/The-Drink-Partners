//
//  NewsDetailsViewController.m
//  TDP
//
//  Created by fernando colman on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "asyncimageview.h"

@implementation NewsDetailsViewController

@synthesize text,textView,image,imageURL,newsTitle;

AsyncImageView* asyncImage;

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
    [textView release];
    [image release];
    [text release];
    [imageURL release];
    [newsTitle release];
    
    [super dealloc];
}

-(void) resetInfo{
    [textView setText:text];
       
//    UIImage * imageAux = [[UIImage alloc] initWithData:imageData]; 
//    image.contentMode = UIViewContentModeScaleAspectFit;
//    [image setImage:imageAux];
    
    //remove async image from superview
    if(asyncImage){
        [asyncImage removeFromSuperview];
    }
    
    //Load async image
    CGRect frame;
	frame.size.width=175; frame.size.height=160;
	frame.origin.x=70; frame.origin.y=0;
	asyncImage = [[[AsyncImageView alloc]
                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL* url = [[NSURL alloc] initWithString:imageURL];
	[asyncImage loadImageFromURL:url];
    
    [url release];
	[self.view addSubview:asyncImage];
    
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = newsTitle;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.textView = nil;
    self.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
