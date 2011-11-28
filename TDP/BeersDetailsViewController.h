//
//  BeersDetailsViewController.h
//  TDP
//
//  Created by fernando colman on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BeersDetailsViewController : UIViewController <NSFetchedResultsControllerDelegate>{
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *image;
    IBOutlet UILabel *lblSize;
    IBOutlet UILabel *lblAbv;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *quantityText;
    IBOutlet UIButton *buttonReduce;
    IBOutlet UIButton *buttonAdd;
    
    NSString *text;
    NSString *imageURL;
    NSString *size;
    NSString *abv;
    NSString *price;
    NSString *beerName;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *lblSize;
@property (nonatomic, retain) UILabel *lblAbv;
@property (nonatomic, retain) UILabel *lblPrice;
@property (nonatomic, retain) UILabel *quantityText;
@property (nonatomic, retain) UIButton *buttonReduce;
@property (nonatomic, retain) UIButton *buttonAdd;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *abv;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *beerName;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;



-(void) resetInfo;
-(IBAction) addClicked:(id) sender;
-(IBAction) reduceClicked:(id) sender;

@end
