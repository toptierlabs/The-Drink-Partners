//
//  BeersTypesViewController.m
//  TDP
//
//  Created by fernando colman on 11/22/11.
//  Copyright 2011 __TopTier labs__. All rights reserved.
//

#import "BeersTypesViewController.h"
#import "SBJson.h"
#import "TDPAppDelegate.h"
#import "PlistHelper.h"
#import "BeersViewController.h"

@implementation BeersTypesViewController

@synthesize tableView, imageView;
@synthesize dicTypesOfBeer, typeOfBeersKeys, beersViewController;


NSManagedObjectContext * managedObjectContext;

//Aux methods
#pragma mark - View lifecycle
NSInteger sort3(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}


//View Controller Methods

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

    [beersViewController release];
    [dicTypesOfBeer release];
    [typeOfBeersKeys release];
    [beersViewController release];
    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Beers";
    
    // Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 70;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    
    //Initialize the beers view controller
    BeersViewController *auxBeersViewController = [[BeersViewController alloc] initWithNibName:@"BeersView" bundle:nil];
    self.beersViewController = auxBeersViewController;
    [auxBeersViewController release];
    
    
    //Get Json from URL
    NSString *beersJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"Beers URL"]]];
    if ([beersJson length] > 0) {
        //Alloc the parser
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        //Parse the Json and get a NSDictionary object
        NSDictionary *dicBeersTypes = [[parser objectWithString:beersJson error:nil] copy]; 
        NSArray *immutableKeys = [dicBeersTypes allKeys];
        
        //Make a mutable array in order to sort the keys (order the beer types)
        NSMutableArray *beerTypesMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
        NSArray *sortedKeys = [beerTypesMutableKeys sortedArrayUsingFunction:&sort3 context:nil];
        
        //Initialize a dictionary to add the valid types of beer. A valid type is the one which doesnt have an empty beers list
        NSMutableDictionary *dicTypes = [[NSMutableDictionary alloc] init];
        
        
        for (NSString *typeKey in sortedKeys) {
            //Check if the beers key is a dictionary (contains beers list)
            if ( [[[dicBeersTypes objectForKey:typeKey] objectForKey:@"beers"]  isKindOfClass:[NSDictionary class]]) {
                //If the beers list is not empty, add it to a new dictionary.
                [dicTypes setValue:[dicBeersTypes objectForKey:typeKey] forKey:typeKey];
            } 
            
        }
        
        NSDictionary *auxTypesOfBeer = [[NSDictionary alloc] initWithDictionary:dicTypes];
        self.dicTypesOfBeer = auxTypesOfBeer;
        self.typeOfBeersKeys = [self.dicTypesOfBeer allKeys];
        
        [dicBeersTypes release];
        [beerTypesMutableKeys release];
        [parser release];
        [auxTypesOfBeer release];
        [dicTypes release];

    }
    
        
    [beersJson release];
   
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    self.tableView = nil;
    self.imageView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) setCoreDataContext: (NSManagedObjectContext *) context{
    managedObjectContext = context;
}

//Table view management methods

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
	return [dicTypesOfBeer count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	UILabel *topLabel;

    NSDictionary *beerType = [dicTypesOfBeer objectForKey: [typeOfBeersKeys objectAtIndex:indexPath.row]];
    

        static NSString *CellIdentifier = @"BeersTypeCell";
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
                         25,
                         aTableView.bounds.size.width,LABEL_HEIGHT)]
             autorelease];
            [cell.contentView addSubview:topLabel];
            
            //
            // Configure the properties for the text that are the same on every row
            //
            topLabel.tag = TOP_LABEL_TAG;
            topLabel.backgroundColor = [UIColor clearColor];
            topLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
            topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] + 3];
            
                    
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

// Event that is executed when the user selects a row in the table
- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *beerType = [dicTypesOfBeer objectForKey: [typeOfBeersKeys objectAtIndex:indexPath.row]];
    
    //Double check if beers list is not empty
    if([[beerType objectForKey:@"beers"] isKindOfClass:[NSDictionary class]]){
        
        // Set the view controller dictionary
        self.beersViewController.dicBeers = [beerType objectForKey:@"beers"];
        
        NSArray *immutableKeys = [self.beersViewController.dicBeers  allKeys];
        NSMutableArray *beerTypesMutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
        
        NSArray *sortedKeys = [beerTypesMutableKeys sortedArrayUsingFunction:&sort3 context:nil];
        
        
        //Set the view controller's sorted key array
        self.beersViewController.beersKeys = sortedKeys;
        
        //Set the beer type name. Used for the title
        self.beersViewController.beerTypeName = [beerType objectForKey:@"name"];
        
        [beerTypesMutableKeys release];
        
        //Reload the table view in the beersviewcontroller
        [self.beersViewController resetInfo];
        
        [self.beersViewController setCoreDataContext:managedObjectContext];
        
        //Push the view
        TDPAppDelegate *delegate = (TDPAppDelegate*) [[UIApplication sharedApplication] delegate];
        [delegate.navBeersController pushViewController:self.beersViewController animated:YES];
        
        
    }

    //Deselect the row before leaving the method
    [aTableView deselectRowAtIndexPath:indexPath animated:NO];   

    
}


@end
