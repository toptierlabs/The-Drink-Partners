//
//  BuyNowViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BuyNowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *tableView;
    UIImageView *imageView;
    UITableViewCell *tableViewCell;
    UILabel *totalLabel;
    UILabel *emptyLabel;
    float totalPrice;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    NSArray *beers;
    
}


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *emptyLabel;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *beers;
@property (nonatomic) float totalPrice;


-(IBAction) emptyCart:(id) sender;
@end
