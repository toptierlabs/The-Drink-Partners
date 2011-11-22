//
//  TDPAppDelegate.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class NavController;

@class BeersViewController;
@class EventsViewController;
@class NewsViewController;
@class BuyNowViewController;
@class AboutViewController;

@class BeersDetailsViewController; 

@interface TDPAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UITabBarController *tabBarController;
    NavController *navBeersController;
    NavController *navEventsController;
    NavController *navNewsController;
    NavController *navBuyNowController;

        
    BeersViewController *beersViewController;
    EventsViewController *eventsViewController;
    NewsViewController *newsViewController;
    BuyNowViewController *buyNowViewController;
    AboutViewController *aboutViewController;
    
    BeersDetailsViewController *beersDetailsViewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NavController *navBeersController;
@property (nonatomic, retain) NavController *navEventsController;
@property (nonatomic, retain) NavController *navNewsController;
@property (nonatomic, retain) NavController *navBuyNowController;


@property (nonatomic, retain) IBOutlet BeersViewController *beersViewController;
@property (nonatomic, retain) IBOutlet EventsViewController *eventsViewController;
@property (nonatomic, retain) IBOutlet NewsViewController *newsViewController;
@property (nonatomic, retain) IBOutlet BuyNowViewController *buyNowViewController;
@property (nonatomic, retain) IBOutlet AboutViewController *aboutViewController;

@property (nonatomic, retain) IBOutlet BeersDetailsViewController *beersDetailsViewController;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;


@end
