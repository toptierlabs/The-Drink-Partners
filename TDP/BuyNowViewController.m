    //
//  BuyNowViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyNowViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Beer.h"
#import "PlistHelper.h"
#import "TDPAppDelegate.h"
#import "asyncimageview.h"

@implementation BuyNowViewController

@synthesize tableView, tableViewCell;
@synthesize managedObjectContext,fetchedResultsController;
@synthesize imageView;
@synthesize beers;
@synthesize emptyLabel;
@synthesize totalLabel, totalPrice;
@synthesize message;
@synthesize beersDetailsController;

// Table events

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Beer *beer = [beers objectAtIndex:indexPath.row];
    self.beersDetailsController.text = beer.text; 

    self.beersDetailsController.imageURL = beer.imageURL;
    
    self.beersDetailsController.size = beer.size;
    self.beersDetailsController.abv = beer.abv;
    self.beersDetailsController.price = beer.priceString;
    self.beersDetailsController.beerName = beer.name;
    
    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navBuyNowController pushViewController:self.beersDetailsController animated:YES];
    [self.beersDetailsController resetInfo];
    
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
	return [beers count];
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
	UILabel *beerTitleLabel;
	UILabel *beerDetailsLabel;
    
    
	static NSString *CellIdentifier = @"Cell";
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
		UIImage *image = [UIImage imageNamed:@"imageA.png"];
        
		//
		// Create the label for the top row of text
		//
		beerTitleLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.3 * (aTableView.rowHeight - 2.7 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:beerTitleLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		beerTitleLabel.tag = TOP_LABEL_TAG;
		beerTitleLabel.backgroundColor = [UIColor clearColor];
		beerTitleLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		beerTitleLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		beerTitleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the botton row of text
		//
		beerDetailsLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 3.0 * cell.indentationWidth,
                     0.12 * (aTableView.rowHeight),
                     aTableView.bounds.size.width + 60 -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width + 40,
                     120)]
         autorelease];
		[cell.contentView addSubview:beerDetailsLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		beerDetailsLabel.tag = BOTTOM_LABEL_TAG;
        beerDetailsLabel.numberOfLines = 4;
		beerDetailsLabel.backgroundColor = [UIColor clearColor];
		beerDetailsLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		beerDetailsLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		beerDetailsLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
        
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
		beerTitleLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		beerDetailsLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
    
    Beer *beer = [beers objectAtIndex:[indexPath row]];
	beerTitleLabel.text = [NSString stringWithFormat:@"%@", beer.name];
	beerDetailsLabel.text = [NSString stringWithFormat:@"Size: %@ml\nAbv: %@\nS$%@\nQuantity: %d", beer.size, beer.abv, beer.priceString, [beer.quantity integerValue]];
    

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
	
		
    CGRect frame;
	frame.size.width=90; frame.size.height=90;
	frame.origin.x=5; frame.origin.y=20;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL* url = [[NSURL alloc] initWithString:beer.imageURL];
	[asyncImage loadImageFromURL:url];
   
    
	[cell.contentView addSubview:asyncImage];

    
	return cell;
}

// End table events


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
    message.hidden = YES;
    self.title = @"Buy Now";

    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view from its nib.
    //
	// Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 135;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
	
    BeersDetailsViewController *auxBeerDetails = [[BeersDetailsViewController alloc] initWithNibName:@"BeersDetailsView" bundle:nil];
    self.beersDetailsController = auxBeerDetails;    
    self.beersDetailsController.managedObjectContext = managedObjectContext;
    

//    beers = [[NSMutableArray alloc] init];
    //
    // Create a background image view.
    //
    tableViewCell.backgroundView = [[[UIImageView alloc] init] autorelease];
    ((UIImageView *)tableViewCell.backgroundView).image = [UIImage imageNamed:@"topAndBottomRow.png"];
    
    UIBarButtonItem *checkoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Check Out"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(checkOut)];
        
    self.navigationItem.rightBarButtonItem = checkoutBtn;
    
}

-(void)checkOut {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSString *subject = [PlistHelper readValue:@"Email Subject"]; 
    [picker setSubject:subject];
    
    NSString *mailTo = [PlistHelper readValue:@"Email Checkout"]; 

    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:mailTo]; 
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];  
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    // Fill out the email body text
    
    NSString *body = @"";
    for (Beer *beer in beers) {
        NSString *beerInfo = [NSString stringWithFormat:@"Name: %@\nUnit price: %@\nQuantity: %d\n\n\n", beer.name, beer.priceString,  [beer.quantity integerValue]];
        body = [NSString stringWithFormat:@"%@%@", body, beerInfo];
    }

    body = [NSString stringWithFormat:@"\n\n\n%@%@", body, [totalLabel text]];

    [picker setMessageBody:body isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message.text = @"Canceled";
            break;
        case MFMailComposeResultSaved:
            message.text = @"Saved";
            break;
        case MFMailComposeResultSent:
            [self removeAllObjects];
            message.text = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message.text = @"Failed";
            break;
        default:
            message.text = @"Not sent";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *mailTo = [PlistHelper readValue:@"Email Checkout"]; 
    NSString *subject = [PlistHelper readValue:@"Email Subject"]; 
    //NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    NSString *recipients = [NSString stringWithFormat: @"mailto:%@&subject=%@", mailTo, subject];
    
    
    NSString *body = @"&body=";
    for (Beer *beer in beers) {
        NSString *beerInfo = [NSString stringWithFormat:@"Name: %@\nUnit price: %@\nQuantity: %.2f\n\n\n", beer.name, beer.priceString, beer.quantity];
        body = [NSString stringWithFormat:@"%@%@", body, beerInfo];
    }
    
    body = [NSString stringWithFormat:@"\n\n\n%@%@", body, [totalLabel text]];

    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
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


-(void) reloadBeerList {
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Beer" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    self.beers = [context executeFetchRequest:fetchRequest error:&error];
    
    self.totalPrice = 0;
    for (Beer *beer in self.beers)
    {
        self.totalPrice += [beer.priceValue floatValue] * [beer.quantity intValue];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"Total S$%.2f", self.totalPrice];
    [self.tableView reloadData];
    
    if ([self.beers count] == 0){
        [emptyLabel setHidden:NO];
    }
    else
        [emptyLabel setHidden:YES];
    [fetchRequest release];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{

    [self reloadBeerList];
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    message.hidden = YES;
}


-(void) removeAllObjects {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * allBeers = [[NSFetchRequest alloc] init];
    [allBeers setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [allBeers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * beerList = [context executeFetchRequest:allBeers error:&error];
    [allBeers release];
    //error handling goes here
    for (NSManagedObject * beer in beerList) {
        [context deleteObject:beer];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    [self reloadBeerList];
    
    [self.tableView reloadData];
}


-(IBAction) emptyCart:(id) sender {
    [self removeAllObjects];
    //Clean budge
    [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
}

@end
