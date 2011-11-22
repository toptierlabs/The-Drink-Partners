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


@implementation BeersViewController

@synthesize tableView;
@synthesize imageView;
@synthesize dicBeers;
@synthesize keys;
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

-(void) resetInfo{
    [tableView reloadData];
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

//To call new view in navigation controller
//    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.navBeerController pushViewController:self.BeerDetailsController animated:YES];
//

#pragma mark - View lifecycle

NSInteger sort2(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Beers";
    
    BeersDetailsViewController *auxBeerDetails = [[BeersDetailsViewController alloc] initWithNibName:@"BeersDetailsView" bundle:nil];
    self.beersDetailsController = auxBeerDetails;    
    self.beersDetailsController.managedObjectContext = managedObjectContext;
//    
//    listOfBeers = [[NSMutableArray alloc] init];
//    NSString *beersJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"Beers URL"]]];
//    if ([beersJson length] == 0) {
//        [beersJson release];
//        return;
//    }
//    
//    SBJsonParser *parser = [[SBJsonParser alloc] init];
//    NSDictionary *dicBeersTypesAux = [[parser objectWithString:beersJson error:nil] copy]; 
    
//    
//    NSArray *immutableKeys = [dicBeersTypesAux allKeys];
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    
//    for (NSString *key in immutableKeys) {
//        
//        NSDictionary *beersAux = [[dicBeersTypesAux objectForKey:key] objectForKey:@"beers"];
//        
//        [dict addEntriesFromDictionary:beersAux];
//    }
//    
//    NSArray *beersImmutableKeys = [dict allKeys];
//    NSMutableArray *beersMutableKeys = [[NSMutableArray alloc] initWithArray:beersImmutableKeys];
//    NSArray *beersKeysBuffer = [beersMutableKeys sortedArrayUsingFunction:&sort2 context:nil];
//
//    self.keys = beersKeysBuffer;
//    
//    NSDictionary *dicBeersAux = [[NSDictionary alloc] initWithDictionary:dict];
//    self.dicBeers = dicBeersAux ;
//    
//    [dicBeersAux release];
//    [dicBeersTypesAux release];
//
//    [beersMutableKeys release];
//    [parser release];
  //  [mutableKeys release];
    
    
   
    
    // Do any additional setup after loading the view from its nib.
    //
	// Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
	
	//
	// Create a header view. Wrap it in a container to allow us to position
	// it better.
	//
	UIView *containerView =
    [[[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 300, 0)]
     autorelease];
	UILabel *headerLabel =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(10, 20, 300, 40)]
     autorelease];
	headerLabel.text = NSLocalizedString(@"Header for the table", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:22];
	headerLabel.backgroundColor = [UIColor clearColor];
//	[containerView addSubview:headerLabel];
	self.tableView.tableHeaderView = containerView;
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
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.3 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the botton row of text
		//
		bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 3.0 * cell.indentationWidth,
                     0.1 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     aTableView.bounds.size.width + 50 -
                     image.size.width - 4.0 * cell.indentationWidth
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
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
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
    
    NSDictionary *beer = [dicBeers objectForKey: [keys objectAtIndex:indexPath.row]];
	
	topLabel.text = [beer objectForKey:@"name"];
    
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
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
    
    NSArray *images = [beer objectForKey:@"images"];
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [images objectAtIndex:0]]; 

    
    //NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];  
    
    cell.image =[UIImage imageNamed:@"imageA.png"];   //[[UIImage alloc] initWithData:imageData]; 
	
	//cell.text = [NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *beer = [dicBeers objectForKey: [keys objectAtIndex:indexPath.row]];
    self.beersDetailsController.text = [beer objectForKey:@"writeup"]; 
    
    NSArray *images = [beer objectForKey:@"images"];
    self.beersDetailsController.imageURL = [NSString stringWithFormat:@"%@%@" , [PlistHelper readValue:@"Base URL"], [images objectAtIndex:0]];
    
    self.beersDetailsController.size = [NSString stringWithFormat:@"%@",[beer objectForKey:@"ml"]];
    self.beersDetailsController.abv = [NSString stringWithFormat:@"%@",[beer objectForKey:@"abv"]];
    self.beersDetailsController.price = [NSString stringWithFormat:@"%@",[beer objectForKey:@"retailprice"]];
    self.beersDetailsController.beerName = [NSString stringWithFormat:@"%@",[beer objectForKey:@"name"]];
    
    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navBeersController pushViewController:self.beersDetailsController animated:YES];
    [self.beersDetailsController resetInfo];
    
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
