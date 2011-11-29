//
//  BeersDetailsViewController.m
//  TDP
//
//  Created by fernando colman on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeersDetailsViewController.h"
#import "asyncimageview.h"

@implementation BeersDetailsViewController

@synthesize textView,image,lblSize,lblAbv,lblPrice,quantityText;
@synthesize size,abv,price,text,imageURL,beerName;
@synthesize managedObjectContext,fetchedResultsController;
@synthesize buttonAdd, buttonReduce;

AsyncImageView* asyncImage;


//Buttons Events
-(IBAction) addClicked:(id) sender{
    
    NSError *error = nil;
   
    //Set formatter style
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //Get quantity and convert to int
    NSNumber * quantity = [formatter numberFromString: quantityText.text];
    int intQuantity = quantity.intValue;
    intQuantity++;
    
    
    NSString *qText = [[NSString alloc] initWithFormat: @"%d",intQuantity];
    [quantityText setText:qText];
    quantity = [NSNumber numberWithInt:intQuantity]; 
    
    int badgeValue =  [formatter numberFromString: [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue].integerValue;
    
    badgeValue ++ ;
    
    NSString *badgeString = [formatter stringFromNumber:[NSNumber numberWithInt:badgeValue]];
    
    //Update badge value
    [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue =badgeString;
    [qText release];
    
    NSManagedObjectContext *context = [self managedObjectContext];

    
    //seek for beer
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
    
    NSManagedObject * beer = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        //Handle any errors
        NSLog(@"Fetch error");
    }
    
    if (!beer) {
        beer = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Beer" 
                                 inManagedObjectContext:context];
        //Nothing there to update
        [beer setValue:beerName forKey:@"name"];
        [beer setValue:price forKey:@"priceString"];
        
        NSNumber * priceValue = [formatter numberFromString: price];
        [beer setValue:priceValue forKey:@"priceValue"];

        [beer setValue:quantity forKey:@"quantity"];
        [beer setValue:abv forKey:@"abv"];
        [beer setValue:size forKey:@"size"];
        [beer setValue:text forKey:@"text"];
        [beer setValue:imageURL forKey:@"imageURL"];
        
        error = nil;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    else{
        //Update the object
        [beer setValue:quantity forKey:@"quantity"];
        //Save it
        error = nil;
        if (![context save:&error]) {
        }
    }

    [request release];
    [formatter release];
    
}
-(IBAction) reduceClicked:(id) sender{
    NSError *error = nil;
    
    //Initialize formatter
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //Get int value of quantity
    NSNumber * quantity = [formatter numberFromString: quantityText.text];
    int intQuantity = quantity.intValue;
    intQuantity--;
        
    if (intQuantity > 0) {
        //Get quantity
        NSString *qText = [[NSString alloc] initWithFormat: @"%d",intQuantity];
        [quantityText setText:qText];
        quantity = [NSNumber numberWithInt:intQuantity];
        
        int badgeValue =  [formatter numberFromString: [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue].integerValue;
        
        badgeValue --;
        
        NSString *badgeString = [formatter stringFromNumber:[NSNumber numberWithInt:badgeValue]];
        
        //Update badge value
        [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue =badgeString;
        [qText release];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        //seek for beer
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
        
         NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
            NSLog(@"Fetch error");
        }
        
        if (beer) {

            //Update the object
            [beer setValue:quantity forKey:@"quantity"];
            //Save it
            error = nil;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }

        [request release];
    }
    else{
        if (intQuantity == 0){
            NSString *qText = [[NSString alloc] initWithFormat: @"%d",intQuantity];
            [quantityText setText:qText];
            [qText release];
            
            [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
        }
        NSManagedObjectContext *context = [self managedObjectContext];

        
        //seek for beer
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
        NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
            NSLog(@"Fetch error");
        }
        
        if (beer) {
            [context deleteObject:beer];
            //Save it
            error = nil;
            if (![context save:&error]) {
                
                 NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        [request release];
        
        
    }
    
    [formatter release];
    
    

}
//EndEvents

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) resetInfo{
    [textView setText:text];
    
    
    NSString *sizeText = [[NSString alloc] initWithFormat: @"Size: %@ml",size];
    NSString *abvText = [[NSString alloc] initWithFormat: @"Abv: %@%%",abv];
    NSString *priceText = [[NSString alloc] initWithFormat: @"S$: %@",price];
    
    [lblSize setText:sizeText];
    [lblAbv setText:abvText];
    [lblPrice setText:priceText];
    
    [sizeText release];
    [abvText release];
    [priceText release];
 
    // Initialize async downloaded file that shows the beer image
    if(asyncImage){
        [asyncImage removeFromSuperview];
    }
    
    CGRect frame;
	frame.size.width=175; frame.size.height=175;
	frame.origin.x=0; frame.origin.y=10;
	asyncImage = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL* url = [[NSURL alloc] initWithString:imageURL];
	[asyncImage loadImageFromURL:url];

    [url release];
    
	[self.view addSubview:asyncImage];
    
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.title = beerName;
    
    // Load images used in buttons to add and remove beers to the cart
    UIImage *imagePlus = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"greenplus" ofType:@"png"]];
    [buttonAdd setImage:imagePlus forState:UIControlStateNormal];
    
    UIImage *imageMinus = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"redminus" ofType:@"png"]];
    [buttonReduce setImage:imageMinus forState:UIControlStateNormal];
    
    
        
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSError *error = nil;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
    
    NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        //Handle any errors
        NSLog(@"Fetching beers error");
    }
    
    if (beer) {
        NSString *qText = [[NSString alloc] initWithFormat: @"%@",[beer valueForKey:@"quantity"]];
        [quantityText setText:qText];
        [qText release];
    }
    else{
        NSString *qText = [[NSString alloc] initWithFormat: @"%d",0];
        [quantityText setText:qText];
        [qText release];
    }
    
    [request release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.textView = nil;
    self.image = nil;
    self.lblSize = nil;
    self.lblAbv = nil;
    self.lblPrice = nil;
    self.quantityText = nil;
    self.buttonReduce = nil;
    self.buttonAdd = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    
    [textView release];
    [image release];
    [lblSize release];
    [lblAbv release];
    [lblPrice release];
    [quantityText release];
    [buttonReduce release];
    [buttonAdd release];
    
    [text release];
    [imageURL release];
    [size release];
    [abv release];
    [price release];
    [beerName release];
    
    [super dealloc];
}

@end
