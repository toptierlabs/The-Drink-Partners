//
//  NewsViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsDetailsViewController;

@interface NewsViewController : UIViewController {
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *imageView;
    
    NSDictionary *dicNews;
    NSArray *keys;
    
    NewsDetailsViewController * newsDetailsViewController;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;

@property(nonatomic, retain) NSDictionary *dicNews;
@property(nonatomic, retain) NSArray *keys;

@property (nonatomic, retain) IBOutlet NewsDetailsViewController *newsDetailsViewController;

@end
 