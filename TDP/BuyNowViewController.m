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

@implementation BuyNowViewController

@synthesize tableView, tableViewCell;
@synthesize managedObjectContext,fetchedResultsController;
@synthesize imageView;
@synthesize beers;
@synthesize emptyLabel;
@synthesize totalLabel, totalPrice;

// Table events

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary *beer = [dicBeers objectForKey: [keys objectAtIndex:indexPath.row]];
//    self.beersDetailsController.text = [beer objectForKey:@"writeup"]; 
//    
//    NSArray *images = [beer objectForKey:@"images"];
//    self.beersDetailsController.imageURL = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [images objectAtIndex:0]];
//    
//    self.beersDetailsController.size = [NSString stringWithFormat:@"%@",[beer objectForKey:@"ml"]];
//    self.beersDetailsController.abv = [NSString stringWithFormat:@"%@",[beer objectForKey:@"abv"]];
//    self.beersDetailsController.price = [NSString stringWithFormat:@"%@",[beer objectForKey:@"retailprice"]];
//    self.beersDetailsController.beerName = [NSString stringWithFormat:@"%@",[beer objectForKey:@"name"]];
//    
//    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.navBeersController pushViewController:self.BuyNowViewController animated:YES];
//    [self.beersDetailsController resetInfo];
    
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
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
	if ((row % 3) == 0)
	{
		cell.image = [UIImage imageNamed:@"imageA.png"];
	}
	else if ((row % 3) == 1)
	{
		cell.image = [UIImage imageNamed:@"imageB.png"];
	}
	else
	{
		cell.image = [UIImage imageNamed:@"imageC.png"];
	}
    
	//cell.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
	
    
    
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
	
	//
	// Create a header view. Wrap it in a container to allow us to position
	// it better.
	//
	UIView *containerView =
    [[[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 300, 50)]
     autorelease];
	UILabel *headerLabel =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(10, 10, 300, 40)]
     autorelease];
	headerLabel.text = NSLocalizedString(@"Cart", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:22];
	headerLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerLabel];
	self.tableView.tableHeaderView = containerView;
    

//    beers = [[NSMutableArray alloc] init];
    //
    // Create a background image view.
    //
    tableViewCell.backgroundView = [[[UIImageView alloc] init] autorelease];
    ((UIImageView *)tableViewCell.backgroundView).image = [UIImage imageNamed:@"topAndBottomRow.png"];
    

    
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    


    [self reloadBeerList];

    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(IBAction) emptyCart:(id) sender {
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

@end
