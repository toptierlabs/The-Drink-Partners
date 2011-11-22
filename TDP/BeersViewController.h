//
//  BeersViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BeersDetailsViewController;

@interface BeersViewController : UIViewController {
    UITableView *tableView;
    UIImageView *imageView;
    
    NSDictionary *dicBeers;
    NSArray *keys;
    
    BeersDetailsViewController *beersDetailsController;

}

@property(nonatomic, retain) NSDictionary *dicBeers;
@property(nonatomic, retain) NSArray *keys;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) IBOutlet BeersDetailsViewController *beersDetailsController;

-(void) setCoreDataContext: (NSManagedObjectContext *) context;
-(void) resetInfo;

@end
