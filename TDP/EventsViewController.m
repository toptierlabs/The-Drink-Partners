//
//  EventsViewController.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsViewController.h"
#import "SBJson.h"
#import "TDPAppDelegate.h"
#import "PlistHelper.h"
#import "EventDetailsViewController.h"
@implementation EventsViewController

@synthesize tableView, imageView;
@synthesize dicEvents, keys;
@synthesize eventDetailsController;


NSMutableArray *listOfEvents;



// Table View Events
- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    const NSInteger TOP_LABEL_TAG = 1001;
    const NSInteger SECOND_LABEL_TAG = 1002;
    static NSString *CellIdentifier = @"CellEvent";
    
    UILabel *mainLabel, *secondLabel;
    NSDictionary *event = [dicEvents objectForKey: [keys objectAtIndex:indexPath.row]];
    
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
        
        //Initialize indicator image
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
        
        const CGFloat LABEL_HEIGHT = 15;
        
        //
        // Create the label for the top row of text
        //
        mainLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     cell.indentationWidth,
                     5,
                     aTableView.bounds.size.width - 60,LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:mainLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        mainLabel.tag = TOP_LABEL_TAG;
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        mainLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        mainLabel.font = [UIFont systemFontOfSize:14.0];;
        

        secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cell.indentationWidth + 30, 23.0, 220.0, 16.0)] autorelease];
        [cell.contentView addSubview:secondLabel];
        secondLabel.font = [UIFont systemFontOfSize:11.0];
        secondLabel.textAlignment = UITextAlignmentLeft;
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textColor = [UIColor darkGrayColor];
        secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        secondLabel.tag = SECOND_LABEL_TAG;
        
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
        mainLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
        secondLabel = (UILabel *)[cell viewWithTag:SECOND_LABEL_TAG];
        
    }
    
    
    mainLabel.text = [event objectForKey: @"title"];
    secondLabel.text = [event objectForKey: @"eventdate"];
    
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
//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [keys count];
}


- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Load thumbnails for the next screen
    NSDictionary *event = [dicEvents objectForKey: [keys objectAtIndex:indexPath.row]];
    self.eventDetailsController.text = [event objectForKey:@"content"];
    NSMutableArray *imagesThumbnails =  [[NSMutableArray alloc] init];
    NSMutableArray *imagesBig =  [[NSMutableArray alloc] init];
    NSArray *images = [event objectForKey:@"images"];

    for (NSDictionary *image in images) {
        [imagesThumbnails addObject:[image objectForKey:@"thumb"]];
        [imagesBig addObject:[image objectForKey:@"big"]];
        
    }
    
    NSArray *thumbnailsArray = [[NSArray alloc] initWithArray:imagesThumbnails];
    self.eventDetailsController.images = thumbnailsArray;
    [thumbnailsArray release];
    
    NSArray *imagesBigArray = [[NSArray alloc] initWithArray:imagesBig];
    self.eventDetailsController.imagesBig = imagesBigArray;
    
    [imagesBigArray release];
    [imagesThumbnails release];
    [imagesBig release];
    
    

    //Reset next screen
    [self.eventDetailsController resetInfo];
    
    
    TDPAppDelegate *delegate = (TDPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.navEventsController pushViewController:self.eventDetailsController animated:YES];
    
    //Deselect row
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];

}


// End Table View Events



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
    [listOfEvents release];
    [tableView release];
    [imageView release];
    [dicEvents release];
    [keys release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

NSInteger sort(id a, id b, void* p) {
    return  [b compare:a options:NSNumericSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"Events";
    EventDetailsViewController *auxeventDetails = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:nil];
    self.eventDetailsController = auxeventDetails;
    [auxeventDetails release];
    
    listOfEvents = [[NSMutableArray alloc] init];
    NSString *eventsJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"Events URL"]]];

    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dicEventsAux = [[parser objectWithString:eventsJson error:nil] copy]; 
    [eventsJson release];
    
    
    self.dicEvents = dicEventsAux;
    [dicEventsAux release];
    
    NSArray *immutableKeys = [dicEvents allKeys];
    NSMutableArray *mutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
    [mutableKeys removeObject: @"otheryears"];
    
    
    NSArray *keysBuffer = [mutableKeys sortedArrayUsingFunction:&sort context:nil];
    self.keys = keysBuffer;

    [parser release];
    [mutableKeys release];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];

    // Do any additional setup after loading the view from its nib.
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




@end
