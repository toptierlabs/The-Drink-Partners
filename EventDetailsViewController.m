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
#import "asyncimageview.h"

@implementation EventDetailsViewController


@synthesize images, imagesBig;
@synthesize text, eventText;
@synthesize image1, image2, image3, image4, image5;
@synthesize imageSliderController;

//Variables for the AsyncImages one for each image
AsyncImageView* asyncImage;
AsyncImageView* asyncImage2;
AsyncImageView* asyncImage3;
AsyncImageView* asyncImage4;
AsyncImageView* asyncImage5;

//Events
-(IBAction) imgClicked:(id) sender
{
    UIButton *theButton = (UIButton *)sender;
    NSInteger index = theButton.tag;
    
    self.imageSliderController.currentPage = index;
    
    TDPAppDelegate *delegate = (TDPAppDelegate*)[[UIApplication sharedApplication] delegate];
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
    [eventText release];
    [image1 release];
    [image2 release];
    [image3 release];
    [image4 release];
    [image5 release];
    
    [images release];
    [imagesBig release];
    [text release];
    
    [imageSliderController release];;
    
    
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

    [image5 setImage:nil forState:UIControlStateNormal];
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

//Method that refresh the controls of the view
-(void) resetInfo
{
    //Set the text to the TextView
    [eventText setText:self.text];
    //Init the buttons
    [self initButtons];
    int i = 1;
    
    //Remove the AsyncImages from the buttons
    if(asyncImage){
        [asyncImage  removeFromSuperview];
        asyncImage = nil;
    }
    if(asyncImage2){
        [asyncImage2 removeFromSuperview];
        asyncImage2 = nil;
    }
    if(asyncImage3){
        [asyncImage3 removeFromSuperview];
        asyncImage3 = nil;
    }
    if(asyncImage4){
        [asyncImage4 removeFromSuperview];
        asyncImage4 = nil;
    }
    if(asyncImage5){
        [asyncImage5 removeFromSuperview];
        asyncImage5 = nil;
    }
    
    //Creates the array of URLs
    NSMutableArray *urlList = [[NSMutableArray alloc] init];
    for (NSString *imageUrl in images)
    {
        if (i <= 5) 
        {
            
            //Creates the URL of the image
            NSString *urlString = [[NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
            NSURL* url = [[NSURL alloc] initWithString:urlString];
            
            //Frame variable for the AsyncImages
            CGRect frame;
            
            
            switch (i)
            {
                case 1:
                    //Crete the frame
                    frame = CGRectMake(5, 15, 110, 140);
                    
                    image1.frame = frame;
                    image1.adjustsImageWhenHighlighted = NO;
                    //Set the action to the button
                    [image1 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    image1.enabled = true;
                    
                    asyncImage = [[[AsyncImageView alloc]
                                                   initWithFrame:frame] autorelease];
                    asyncImage.tag = 990;
                    //Create the AsyncImage whith the URL
                    [asyncImage loadImageFromURL:url];
                    
                    //Add the AsyncImage to the Button    
                    [image1 addSubview:asyncImage];
                    
                    break;
                case 2:
                    //Crete the frame
                    frame = CGRectMake(70, 5, 80, 80);
                    
                    image2.frame = frame;
                    //Set the action to the button
                    [image2 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                    image2.adjustsImageWhenHighlighted = NO;
                    image2.enabled = true;
                    
                    asyncImage2 = [[[AsyncImageView alloc]
                                                   initWithFrame:frame] autorelease];
                    asyncImage2.tag = 991;
                    
                    //Create the AsyncImage whith the URL
                    [asyncImage2 loadImageFromURL:url];
                    
                     //Add the AsyncImage to the Button 
                    [image2 addSubview:asyncImage2];

                    break;
                case 3:
                    //Crete the frame
                    frame = CGRectMake(115, 5, 80, 80);

                    image3.frame = frame;
                    image3.adjustsImageWhenHighlighted = NO;
                    //Set the action to the button
                    [image3 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                     image3.enabled = true;
                    
                    asyncImage3 = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
                    
                    asyncImage3.tag = 992;
                    
                    //Create the AsyncImage whith the URL
                    [asyncImage3 loadImageFromURL:url];
                    
                    //Add the AsyncImage to the Button 
                    [image3 addSubview:asyncImage3];
                   
                    break;
                case 4:
                    //Crete the frame
                    frame = CGRectMake(70, 40, 80, 80);
                    
                    image4.frame = frame;
                    image4.adjustsImageWhenHighlighted = NO;
                    //Set the action to the button
                    [image4 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                     image4.enabled = true;
                    
                    asyncImage4 = [[[AsyncImageView alloc]
                                                    initWithFrame:frame] autorelease];
                    asyncImage4.tag = 993;
                    
                    //Create the AsyncImage whith the URL
                    [asyncImage4 loadImageFromURL:url];
                    
                    //Add the AsyncImage to the Button 
                    [image4 addSubview:asyncImage4];
                   
                    break;
                case 5:
                    //Crete the frame
                    frame = CGRectMake(115, 40, 80, 80);
                    
                    image5.frame = frame;
                    image5.adjustsImageWhenHighlighted = NO;
                    //Set the action to the button
                    [image5 addTarget:self action:@selector(imgClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
                     image5.enabled = true;
                    
                    asyncImage5 = [[[AsyncImageView alloc]
                                                    initWithFrame:frame] autorelease];
                    asyncImage5.tag = 994;
                    //Create the AsyncImage whith the URL
                    [asyncImage5 loadImageFromURL:url];
                    
                    //Add the AsyncImage to the Button 
                    [image5 addSubview:asyncImage5];
              
                    break;
                    
                default:
                    
                    break;
                    
            }
            
            [url release];
        }
        
        
        //Create the URL of the image and add it to the collection
        NSString *imageBigUrl = [imagesBig objectAtIndex:(i-1)];
        NSString *urlBigString = [[NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], imageBigUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
        NSURL* urlBig = [[NSURL alloc] initWithString:urlBigString];
        [urlList addObject:urlBig];
        
        [urlBig release];
        
        i++;
    }
    //Set the collection of URLs to the slider view
    self.imageSliderController.views = urlList;
    [urlList release];
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
    
    //Create the Slider Controller
    ImageSliderViewController *auximageSlider = [[ImageSliderViewController alloc] initWithNibName:@"ImageSliderView" bundle:nil];
    self.imageSliderController = auximageSlider;
    [auximageSlider release];


    
}

-(void) viewWillAppear:(BOOL)animated{
    //When the view appears reloads de info of the view
    [self resetInfo];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.eventText = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
