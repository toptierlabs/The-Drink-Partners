//
//  EventDetailsViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "PlistHelper.h"
#import "ImageSliderViewController.h"
#import "TDPAppDelegate.h"

@implementation EventDetailsViewController


@synthesize images, imagesBig;
@synthesize text, textView;
@synthesize image1, image2, image3, image4, image5;
@synthesize lastImagesSize;
@synthesize imageSliderController;
//@synthesize scrollView;


//Events
-(IBAction) imgClicked:(id) sender
{
    UIButton *theButton = (UIButton *)sender;
    NSInteger index = theButton.tag;
    
    self.imageSliderController.currentPage = index;
    
    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navEventsController pushViewController:self.imageSliderController animated:YES];
    
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
    [textView release];
    [image1 release];
    [image2 release];
    [image3 release];
    [image4 release];
    [image5 release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) initButtons
{

    [image5 setImage:nil forState:UIControlStateNormal];;
    [image4 setImage:nil forState:UIControlStateNormal];
    [image3 setImage:nil forState:UIControlStateNormal];
    [image2 setImage:nil forState:UIControlStateNormal];
    [image1 setImage:nil forState:UIControlStateNormal];

    
    image1.enabled = false;
    image2.enabled = false;
    image3.enabled = false;
    image4.enabled = false;
    image5.enabled = false;
    
}

-(void) resetInfo
{
    [textView setText:self.text];
    [self initButtons];
    int i = 1;
    
    
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    for (NSString *imageUrl in images)
    {
        if (i <= 5) 
        {
            
            NSString *urlString = [[NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];  
            UIImage *newImage = [[UIImage alloc] initWithData:imageData];
            switch (i)
            {
                case 1:
                    image1.frame = CGRectMake(13, 15, 136, 178);
                    image1.adjustsImageWhenHighlighted = NO;
                    [image1 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    image1.enabled = true;
                    [image1 setImage:newImage forState:UIControlStateNormal];
                    break;
                case 2:
                    image2.frame = CGRectMake(165, 15, 60, 60);
                    [image2 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    image2.adjustsImageWhenHighlighted = NO;
                    image2.enabled = true;
                    [image2 setImage:newImage forState:UIControlStateNormal];
                    break;
                case 3:
                    image3.frame = CGRectMake(251, 15, 60, 60);
                    image3.adjustsImageWhenHighlighted = NO;
                    [image3 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [image3 setImage:newImage forState:UIControlStateNormal];
                    image3.enabled = true;
                    break;
                case 4:
                    image4.frame = CGRectMake(165, 97, 60, 60);
                    image4.adjustsImageWhenHighlighted = NO;
                    [image4 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [image4 setImage:newImage forState:UIControlStateNormal];
                    image4.enabled = true;
                   
                    break;
                case 5:
                    image5.frame = CGRectMake(251, 97, 60, 60);
                    image5.adjustsImageWhenHighlighted = NO;
                    [image5 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [image5 setImage:newImage forState:UIControlStateNormal];
                    image5.enabled = true;
                    
                    break;
                    
                default:
                    
                    break;
                    
            }
            self.lastImagesSize = i;
            [newImage release];
        }
        else
            break;
        
        NSString *imageBigUrl = [imagesBig objectAtIndex:(i-1)];
        NSString *urlBigString = [[NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], imageBigUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
        NSData* imageBigData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlBigString]];  
        UIImage *newBigImage = [[UIImage alloc] initWithData:imageBigData];
        [imageList addObject:newBigImage];
        
        i++;
    }
    self.imageSliderController.views = imageList;
    [imageList release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    image1 = [UIButton buttonWithType:UIButtonTypeCustom];
    image2 = [UIButton buttonWithType:UIButtonTypeCustom];
    image3 = [UIButton buttonWithType:UIButtonTypeCustom];
    image4 = [UIButton buttonWithType:UIButtonTypeCustom];
    image5 = [UIButton buttonWithType:UIButtonTypeCustom];
    image1.tag = 0;
    image2.tag = 1;
    image3.tag = 2;
    image4.tag = 3;
    image5.tag = 4;
    
    [self.view addSubview:image1];
    [self.view addSubview:image2];
    [self.view addSubview:image3];
    [self.view addSubview:image4];
    [self.view addSubview:image5];
    
    
    ImageSliderViewController *auximageSlider = [[ImageSliderViewController alloc] initWithNibName:@"ImageSliderView" bundle:nil];
    self.imageSliderController = auximageSlider;
    [auximageSlider release];
    // Do any additional setup after loading the view from its nib.


    
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
