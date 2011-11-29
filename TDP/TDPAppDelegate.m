//
//  TDPAppDelegate.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDPAppDelegate.h"
#import "NavController.h"
#import "BeersViewController.h"
#import "EventsViewController.h"
#import "NewsViewController.h"
#import "BuyNowViewController.h"
#import "AboutViewController.h"

#import "BeersDetailsViewController.h"
#import "BeersTypesViewController.h"

@implementation TDPAppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;

@synthesize navBeersController;
@synthesize navEventsController;
@synthesize navNewsController;
@synthesize navBuyNowController;


@synthesize beersTypesViewController;
@synthesize eventsViewController;
@synthesize newsViewController;
@synthesize buyNowViewController;
@synthesize aboutViewController;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    tabBarController = [[UITabBarController alloc] init];   
    
    //Create view controllers
    beersTypesViewController = [[BeersTypesViewController alloc] init];
    eventsViewController = [[EventsViewController alloc] init];
    newsViewController = [[NewsViewController alloc] init];
    buyNowViewController = [[BuyNowViewController alloc] init];
    aboutViewController = [[AboutViewController alloc] init];
    
    
    [beersTypesViewController setCoreDataContext: self.managedObjectContext];
     buyNowViewController.managedObjectContext = self.managedObjectContext;
    
    //Create navigation controllers
    navBeersController = [[[NavController alloc] initWithRootViewController:beersTypesViewController] autorelease];
    navEventsController = [[[NavController alloc] initWithRootViewController:eventsViewController] autorelease];
    navNewsController = [[[NavController alloc] initWithRootViewController:newsViewController] autorelease];
    navBuyNowController = [[[NavController alloc] initWithRootViewController:buyNowViewController] autorelease];
    
    //Set titles
    navBeersController.title = @"Beers";
    navEventsController.title = @"Events";
    navNewsController.title = @"News";
    navBuyNowController.title = @"Buy Now";
    aboutViewController.title = @"About";
    
    // Set navigation bar color
    navBeersController.navigationBar.tintColor = [UIColor blackColor];
    navEventsController.navigationBar.tintColor = [UIColor blackColor];
    navNewsController.navigationBar.tintColor = [UIColor blackColor];
    navBeersController.navigationBar.tintColor = [UIColor blackColor];
    navBuyNowController.navigationBar.tintColor = [UIColor blackColor];
    
    //Set tab bar images
    navBeersController.tabBarItem.image = [UIImage imageNamed:@"beer-mug.png"];
    navEventsController.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];
    navNewsController.tabBarItem.image = [UIImage imageNamed:@"news.png"];
    navBuyNowController.tabBarItem.image = [UIImage imageNamed:@"shopping-cart.png"];
    aboutViewController.tabBarItem.image = [UIImage imageNamed:@"envelope.png"];
    
    // Add view controllers to the tab bar controller
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navBeersController, navEventsController, navNewsController, navBuyNowController, aboutViewController, nil];
    
    //Refresh buyNow budge
    //Set up context
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * allBeers = [[NSFetchRequest alloc] init];
    [allBeers setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [allBeers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    //Get all beers
    NSArray * beerList = [context executeFetchRequest:allBeers error:&error];
    [allBeers release];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //Variable to sum the quantity of the beers
    int quntityBeers = 0;
    for (NSManagedObject * beer in beerList) {

        //Get the quantity of the beers from the database
        NSString *qText = [[NSString alloc] initWithFormat: @"%@",[beer valueForKey:@"quantity"]];
        int q = [formatter numberFromString: qText].integerValue;
        quntityBeers += q;
        [qText release];
        
    }
    if (quntityBeers) {
        NSString *badgeString = [formatter stringFromNumber:[NSNumber numberWithInt:quntityBeers]];
        //Update badge value
        [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue =badgeString;
    }
    [formatter release];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

//Core data
//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"<Project Name>.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//End core data

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
