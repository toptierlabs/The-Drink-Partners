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

@interface BeersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *imageView;
    
    NSString *beerTypeName;
    NSDictionary *dicBeers;
    NSArray *beersKeys;
    
    BeersDetailsViewController *beersDetailsController;

}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;

@property(nonatomic, retain) NSDictionary *dicBeers;
@property(nonatomic, retain) NSArray *beersKeys;
@property(nonatomic, retain) NSString *beerTypeName;

@property (nonatomic, retain) BeersDetailsViewController *beersDetailsController;

-(void) setCoreDataContext: (NSManagedObjectContext *) context;
-(void) resetInfo;

@end
