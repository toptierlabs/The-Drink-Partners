//
//  EventDetailsViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "PlistHelper.h"

@implementation EventDetailsViewController


@synthesize images;
@synthesize text;
@synthesize textView;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize image5;
//@synthesize scrollView;

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
    // Do any additional setup after loading the view from its nib.
    
//    scrollView.frame = CGRectMake(0, 202, 320, 210);
//    [scrollView setContentSize:CGSizeMake(320, 650)];
    [textView setText:self.text];
    
    int i = 1;
    for (NSString *imageUrl in images)
    {
        if (i <= 5) 
        {
            NSString *urlString = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], imageUrl]; 
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];  
            switch (i)
            {
                case 1:
                    image1.image = [[UIImage alloc] initWithData:imageData]; 
                    break;
                    
                case 2:
                    image2.image = [[UIImage alloc] initWithData:imageData];
                    break;
                case 3:
                    image3.image = [[UIImage alloc] initWithData:imageData];
                    break;
                case 4:
                    image4.image = [[UIImage alloc] initWithData:imageData];
                    break;
                case 5:
                    image5.image = [[UIImage alloc] initWithData:imageData];
                    break;
                    
                default:
                    
                    break;
                    
            }
        }
        else
            break;

        i++;
    }
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

@end
