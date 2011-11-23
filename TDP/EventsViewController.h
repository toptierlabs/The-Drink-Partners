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
  
}

@property(nonatomic, retain) NSDictionary *dicEvents;
@property(nonatomic, retain) NSArray *keys;
@property (nonatomic,retain) EventDetailsViewController * eventDetailsController;


-(id)initWithFrame:(CGRect) theFrame;

@end
