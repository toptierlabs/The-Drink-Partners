//
//  BeersTypesViewController.h
//  TDP
//
//  Created by fernando colman on 11/22/11.
//  Copyright 2011 __TopTier labs__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BeersViewController;

@interface BeersTypesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    //Outlets
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *imageView;
    
    //Dictionary initialized used parsed jason
    NSDictionary *dicTypesOfBeer;
    //Dictionary keys
    NSArray *typeOfBeersKeys;
    
    //View controller that shows the list of beers for a type of beer
    BeersViewController *beersViewController;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;

@property(nonatomic, retain) NSDictionary *dicTypesOfBeer;
@property(nonatomic, retain) NSArray *typeOfBeersKeys;

@property (nonatomic, retain) BeersViewController *beersViewController;

-(void) setCoreDataContext: (NSManagedObjectContext *) context;
@end
