//
//  BeersTypesViewController.m
//  TDP
//
//  Created by fernando colman on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeersTypesViewController.h"
#import "SBJson.h"
#import "TDPAppDelegate.h"
#import "PlistHelper.h"
#import "BeersViewController.h"

@implementation BeersTypesViewController

@synthesize tableView,imageView,dicBeers,keys,beersViewController;

NSMutableArray *listOfBeers;
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
    [listOfBeers release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
NSInteger sort3(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Beers";
    
    BeersViewController *auxBeerDetails = [[BeersViewController alloc] initWithNibName:@"BeersView" bundle:nil];
    self.beersViewController = auxBeerDetails;
    
    listOfBeers = [[NSMutableArray alloc] init];
    NSString *beersJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"Beers URL"]]];
    if ([beersJson length] == 0) {
        [beersJson release];
        return;
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dicBeersTypes = [[parser objectWithString:beersJson error:nil] copy]; 
    
    
    NSArray *immutableKeys = [dicBeersTypes allKeys];
    
    
    NSMutableArray *beersMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
    NSArray *beersKeysBuffer = [beersMutableKeys sortedArrayUsingFunction:&sort3 context:nil];
    
  
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSMutableArray *aux = [[NSMutableArray alloc] init];
        
        for (NSString *key in beersKeysBuffer) {
            
            NSDictionary *beersAux = [dicBeersTypes objectForKey:key];
            if([[[dicBeersTypes objectForKey:key] objectForKey:@"beers"]  isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",[[dicBeersTypes objectForKey:key] objectForKey:@"name"]);
                [dict setValue:[dicBeersTypes objectForKey:key] forKey:key];
            }
            
        }
    
    
    self.dicBeers = [[NSDictionary alloc] initWithDictionary:dict];
    self.keys = [self.dicBeers allKeys];
    
    
    [beersMutableKeys release];
    [parser release];
    
    // Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
	
	

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
    NSDictionary *beerType = [dicBeers objectForKey: [keys objectAtIndex:indexPath.row]];
    

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
            
            //
            // Create the label for the top row of text
            //
            topLabel =
            [[[UILabel alloc]
              initWithFrame:
              CGRectMake(
                         cell.indentationWidth,
                         0.3 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                         aTableView.bounds.size.width,LABEL_HEIGHT)]
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

        }
        
        
        
        topLabel.text = [beerType objectForKey:@"name"];
        
        
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
        

        
        return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *beerType = [dicBeers objectForKey: [keys objectAtIndex:indexPath.row]];
    
    //self.beersDetailsController.text = [beer objectForKey:@"writeup"]; 
    if([[beerType objectForKey:@"beers"] isKindOfClass:[NSDictionary class]]){
        self.beersViewController.dicBeers = [beerType objectForKey:@"beers"];
        
        NSArray *immutableKeys = [self.beersViewController.dicBeers  allKeys];
        NSMutableArray *beersMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
        NSArray *beersKeysBuffer = [beersMutableKeys sortedArrayUsingFunction:&sort3 context:nil];
        
        self.beersViewController.keys = beersKeysBuffer;
        
        [beersMutableKeys release];
        
        [self.beersViewController resetInfo];
        TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navBeersController pushViewController:self.beersViewController animated:YES];
        [self.beersViewController setCoreDataContext:managedObjectContext];
        
    }

   

    
}


@end
