//
//  BeersTypesViewController.h
//  TDP
//
//  Created by fernando colman on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BeersViewController;

@interface BeersTypesViewController : UIViewController{
    UITableView *tableView;
    UIImageView *imageView;
    
    NSDictionary *dicBeers;
    NSArray *keys;
    
    BeersViewController *beersViewController;
}

@property(nonatomic, retain) NSDictionary *dicBeers;
@property(nonatomic, retain) NSArray *keys;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) IBOutlet BeersViewController *beersViewController;

-(void) setCoreDataContext: (NSManagedObjectContext *) context;
@end
