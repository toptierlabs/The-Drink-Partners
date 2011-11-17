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


@synthesize dicEvents;
@synthesize keys;
@synthesize eventDetailsController;

NSMutableArray *listOfEvents;

// Table View Events
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *mainLabel, *secondLabel;
    
    
    //---try to get a reusable cell---
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier]
                autorelease];
    }
    
    //---set the text to display for the cell---
    NSDictionary *event = [dicEvents objectForKey: [keys objectAtIndex:indexPath.row]];
    NSString *cellValue = [event objectForKey: @"title"];
    NSString *dateValue = [event objectForKey: @"eventdate"];
    
    mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8, 3.0, 290.0,20.0)] autorelease];
    mainLabel.font = [UIFont boldSystemFontOfSize:13.0];
    mainLabel.textAlignment = UITextAlignmentLeft;
    mainLabel.textColor = [UIColor blackColor];
    mainLabel.text = cellValue;

    mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:mainLabel];
    
    secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(8, 23.0, 220.0, 16.0)] autorelease];
    secondLabel.font = [UIFont systemFontOfSize:12.0];
    secondLabel.textAlignment = UITextAlignmentLeft;
    secondLabel.textColor = [UIColor darkGrayColor];
    secondLabel.text = dateValue;
    secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:secondLabel];
    
//    cell.textLabel.text = cellValue;
//    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    
    return cell;
}
//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [keys count];
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *event = [dicEvents objectForKey: [keys objectAtIndex:indexPath.row]];
    self.eventDetailsController.text = [event objectForKey:@"content"];
    NSMutableArray *imagesThumbnails =  [[NSMutableArray alloc] init];
    NSMutableArray *imagesBig =  [[NSMutableArray alloc] init];
    NSArray *images = [event objectForKey:@"images"];

    for (NSDictionary *image in images) {
        [imagesThumbnails addObject:[image objectForKey:@"thumb"]];
        [imagesBig addObject:[image objectForKey:@"big"]];
        
    }
    
    self.eventDetailsController.images = [[NSArray alloc] initWithArray:imagesThumbnails];
    self.eventDetailsController.imagesBig = [[NSArray alloc] initWithArray:imagesBig];
    [imagesThumbnails release];
    [imagesBig release];
    
    TDPAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navEventsController pushViewController:self.eventDetailsController animated:YES];
    [self.eventDetailsController resetInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
    self.title = @"Events";
    EventDetailsViewController *auxeventDetails = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:nil];
    self.eventDetailsController = auxeventDetails;
    [auxeventDetails release];
    
    listOfEvents = [[NSMutableArray alloc] init];
    NSString *eventsJson =  [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[PlistHelper readValue:@"Events URL"]]];
    if ([eventsJson length] == 0) {
        [eventsJson release];
        return;
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dicEventsAux = [[parser objectWithString:eventsJson error:nil] copy]; 
    self.dicEvents = dicEventsAux;
    [dicEventsAux release];
    
    NSArray *immutableKeys = [dicEvents allKeys];
    NSMutableArray *mutableKeys = [[NSMutableArray alloc] initWithArray:immutableKeys];
    [mutableKeys removeObject: @"otheryears"];
    
    
    NSArray *keysBuffer = [mutableKeys sortedArrayUsingFunction:&sort context:nil];
    self.keys = keysBuffer;
    

    [parser release];
    [mutableKeys release];
    
    [super viewDidLoad];
    
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
