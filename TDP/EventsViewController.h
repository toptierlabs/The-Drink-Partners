//
//  EventsViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventDetailsViewController;
@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSDictionary *dicEvents;
    NSArray *keys;
    UITableView *tableView;
    UIImageView *imageView;
}

@property(nonatomic, retain) NSDictionary *dicEvents;
@property(nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) EventDetailsViewController * eventDetailsController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


-(id)initWithFrame:(CGRect) theFrame;

@end
