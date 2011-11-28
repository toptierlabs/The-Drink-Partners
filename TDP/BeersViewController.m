//
//  BeersViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeersViewController.h"
#import "SBJson.h"
#import "TDPAppDelegate.h"
#import "PlistHelper.h"
#import "BeersDetailsViewController.h"
#import "asyncimageview.h"


@implementation BeersViewController

@synthesize tableView, imageView;
@synthesize dicBeers, beersKeys, beerTypeName;
@synthesize beersDetailsController;

NSManagedObjectContext * managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setCoreDataContext: (NSManagedObjectContext *) context{
    managedObjectContext = context;
}



- (void)dealloc
{
    [tableView release];
    [imageView release];
    [beerTypeName release];
    [dicBeers release];
    [beersDetailsController release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
NSInteger sort2(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}

-(void)viewWillAppear:(BOOL)animated{
    //Refresh the title every time that the view will appear
    self.title = beerTypeName;
}   

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
    //
	// Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    BeersDetailsViewController *auxBeerDetails = [[BeersDetailsViewController alloc] initWithNibName:@"BeersDetailsView" bundle:nil];
    self.beersDetailsController = auxBeerDetails;    
    [auxBeerDetails release];
    self.beersDetailsController.managedObjectContext = managedObjectContext;
}

// Method that transforms the image displayed in a custom view
UIImage *scaleAndRotateImage(UIImage *image,int kMaxResolution)  
{  
    
    CGImageRef imgRef = image.CGImage;  
    
    CGFloat width = CGImageGetWidth(imgRef);  
    CGFloat height = CGImageGetHeight(imgRef);  
    
    CGAffineTransform transform = CGAffineTransformIdentity;  
    CGRect bounds = CGRectMake(0, 0, width, height);  
    if (width > kMaxResolution || height > kMaxResolution) {  
        CGFloat ratio = width/height;  
        if (ratio > 1) {  
            bounds.size.width = kMaxResolution;  
            bounds.size.height = bounds.size.width / ratio;  
        }  
        else {  
            bounds.size.height = kMaxResolution;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = image.imageOrientation;  
    switch(orient) {  
            
        case UIImageOrientationUp: //EXIF = 1  
            transform = CGAffineTransformIdentity;  
            break;  
            
        case UIImageOrientationUpMirrored: //EXIF = 2  
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            break;  
            
        case UIImageOrientationDown: //EXIF = 3  
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
            transform = CGAffineTransformRotate(transform, M_PI);  
            break;  
            
        case UIImageOrientationDownMirrored: //EXIF = 4  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
            transform = CGAffineTransformScale(transform, 1.0, -1.0);  
            break;  
            
        case UIImageOrientationLeftMirrored: //EXIF = 5  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationLeft: //EXIF = 6  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRightMirrored: //EXIF = 7  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRight: //EXIF = 8  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        default:  
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
            
    }  
    
    UIGraphicsBeginImageContext(bounds.size);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    }  
    else {  
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    }  
    
    CGContextConcatCTM(context, transform);  
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return imageCopy;  
} 

// Parses the url and appends resized string to it.
NSString *addStringToURL(NSString * urlString){
    
    NSMutableString *stringBuffer = [[NSMutableString alloc] init];
    
    NSUInteger urlLength = [urlString length];
    if (urlLength > 0) {
        for (int i = 0; i < urlLength; i++) {
            int index = urlLength - 1 - i;
            NSString *compare = @"/";
            if ([urlString characterAtIndex:index] == [compare characterAtIndex:0]){
                NSString * substring = [urlString substringToIndex:index];
                NSString * tail = [urlString substringFromIndex:index];
                [stringBuffer appendString:substring];
                [stringBuffer appendString:@"/resized"];
                [stringBuffer appendString:tail];
                break;
            }
        }
    }
    [stringBuffer release];
    return urlString;
}


//Table events

// Reload the tableview data
-(void) resetInfo{
    [tableView reloadData];
}

//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dicBeers count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;

    
	static NSString *CellIdentifier = @"BeerCell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
        [[[UITableViewCell alloc]
          initWithFrame:CGRectZero
          reuseIdentifier:CellIdentifier]
         autorelease];
        

		UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;
        
		//
		// Create the label for the top row of text
		//
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     8 * cell.indentationWidth,
                     0.3 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     15 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the botton row of text
		//
		bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     8 * cell.indentationWidth,
                     0.1 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     aTableView.bounds.size.width + 50 -
                     15 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT+50)]
         autorelease];
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
        bottomLabel.numberOfLines = 3;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
        
		//
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];

	}

	else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
    
    // Get the current index key and object in the dictionary
    NSDictionary *beer = [dicBeers objectForKey: [beersKeys objectAtIndex:indexPath.row]];
	
    //Set the name of the beer
	topLabel.text = [beer objectForKey:@"name"];
    
    //Set the info of the beer
	bottomLabel.text = [NSString stringWithFormat:@"Size: %@ml\nAbv: %@%%\nS$ %@",[beer objectForKey:@"ml"],[beer objectForKey:@"abv"],[beer objectForKey:@"retailprice"] ];
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	

    // Builds the url of the images
    NSArray *images = [beer objectForKey:@"images"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [images objectAtIndex:0]]; 
    
    // Add the resize text to the url 
    urlString = addStringToURL(urlString);
    
    // Initialize async call to load image
    CGRect frame;
	frame.size.width=75; frame.size.height=75;
	frame.origin.x=0; frame.origin.y=7;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL* url = [[NSURL alloc] initWithString:urlString];
	[asyncImage loadImageFromURL:url];
    
    if ([[cell.contentView subviews] count]>2) {
		//then this must be another image, the old one is still in subviews
		 [[[cell.contentView subviews] objectAtIndex:2] removeFromSuperview]; //so remove it (releases it also)
	}
    //Add the async image to the cell
	[cell.contentView addSubview:asyncImage];
    
    [url release];
	return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Gets the beer
    NSDictionary *beer = [dicBeers objectForKey: [beersKeys objectAtIndex:indexPath.row]];
    
    //Set beer's details
    self.beersDetailsController.text = [beer objectForKey:@"writeup"]; 
    
    //Set the image URL for the string
    NSArray *images = [beer objectForKey:@"images"];
    self.beersDetailsController.imageURL = addStringToURL([NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [images objectAtIndex:0]]);
    
    //Set all the beer's info
    self.beersDetailsController.size = [NSString stringWithFormat:@"%@",[beer objectForKey:@"ml"]];
    self.beersDetailsController.abv = [NSString stringWithFormat:@"%@",[beer objectForKey:@"abv"]];
    self.beersDetailsController.price = [NSString stringWithFormat:@"%@",[beer objectForKey:@"retailprice"]];
    self.beersDetailsController.beerName = [NSString stringWithFormat:@"%@",[beer objectForKey:@"name"]];
    
    //Call the Beer details view
    TDPAppDelegate *delegate = (TDPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.navBeersController pushViewController:self.beersDetailsController animated:YES];
    [self.beersDetailsController resetInfo];
    
     [aTableView deselectRowAtIndexPath:indexPath animated:YES];  
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.tableView = nil;
    self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void) viewWillAppear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [super viewWillAppear:animated];
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}

@end
