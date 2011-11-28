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
    IBOutlet UITableView *tableView;  // Table
    IBOutlet UIImageView *imageView;  //Background image
    IBOutlet UITableViewCell *tableViewCell; // total price cell
    IBOutlet UILabel *totalLabel; // total price label
    IBOutlet UILabel *emptyLabel; //Empty cart message
    IBOutlet UILabel *message;     // Mail status label 
    
    float totalPrice;
    
    //Core data stuff
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
    //beers in the cart
    NSArray *beers;
    
    //Details of a beer
    BeersDetailsViewController *beersDetailsController;
}

@property (nonatomic, retain) UILabel *message;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITableViewCell *tableViewCell;
@property (nonatomic, retain) UILabel *totalLabel;
@property (nonatomic, retain) UILabel *emptyLabel;

@property (nonatomic, retain) BeersDetailsViewController *beersDetailsController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *beers;
@property (nonatomic) float totalPrice;


-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void) removeAllObjects;

-(IBAction) emptyCart:(id) sender;
-(void) checkOut;
@end 
