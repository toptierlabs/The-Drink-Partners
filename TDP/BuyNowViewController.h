//
//  BuyNowViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BeersDetailsViewController.h"

@interface BuyNowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>{
    UITableView *tableView;
    UIImageView *imageView;
    UITableViewCell *tableViewCell;
    UILabel *totalLabel;
    UILabel *emptyLabel;
    float totalPrice;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    NSArray *beers;
    IBOutlet UILabel *message;
    
    BeersDetailsViewController *beersDetailsController;
}

@property (nonatomic, retain) IBOutlet UILabel *message;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *emptyLabel;

@property (nonatomic, retain) BeersDetailsViewController *beersDetailsController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *beers;
@property (nonatomic) float totalPrice;

-(IBAction)showPicker:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void) removeAllObjects;

-(IBAction) emptyCart:(id) sender;
-(void) checkOut;
@end
