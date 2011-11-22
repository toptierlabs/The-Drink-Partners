//
//  BeersDetailsViewController.m
//  TDP
//
//  Created by fernando colman on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeersDetailsViewController.h"

@implementation BeersDetailsViewController

@synthesize textView,image,label1,label2,label3,quantityText;
@synthesize size,abv,price,text,imageURL,beerName;
@synthesize managedObjectContext,fetchedResultsController;
@synthesize buttonAdd, buttonReduce;

//Events
-(IBAction) addClicked:(id) sender{
    
    NSError *error = nil;
   
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber * quantity = [f numberFromString: quantityText.text];
    int q = quantity.intValue;
    q++;
    NSString *qText = [NSString stringWithFormat:@"%d",q];
    [quantityText setText:qText];
    quantity = [NSNumber numberWithInt:q]; 
    
    NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObject *beer = [NSEntityDescription
//                             insertNewObjectForEntityForName:@"Beer" 
//                             inManagedObjectContext:context];
    
    //seek for beer
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
    
    NSManagedObject * beer = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        //Handle any errors
        NSLog(@"Hay un erro al hacer fetch de beer para update");
    }
    
    if (!beer) {
        beer = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Beer" 
                                 inManagedObjectContext:context];
         NSLog(@"haciendo insert");
        //Nothing there to update
        [beer setValue:beerName forKey:@"name"];
        [beer setValue:price forKey:@"priceString"];
        
        
        
        NSNumber * priceValue = [f numberFromString: price];
        
        [beer setValue:priceValue forKey:@"priceValue"];
        
        NSLog(@"quantityText.text = %@",quantityText.text);
        
        [beer setValue:quantity forKey:@"quantity"];
        
        error = nil;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    else{
         NSLog(@"haciendo update");
        //Update the object
        [beer setValue:quantity forKey:@"quantity"];
        //Save it
        error = nil;
        if (![context save:&error]) {
        }
    }

    
    //LOG-SACAR!!
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Beer" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        if (![info isDeleted]){
            NSLog(@"Name: %@", [info valueForKey:@"name"]);
            NSLog(@"Price: %@", [info valueForKey:@"priceString"]);
            NSLog(@"Price: %@", [info valueForKey:@"priceValue"]);
            NSLog(@"Quantity: %@", [info valueForKey:@"quantity"]);
        }
    }    
    
    [f release];
    [request release];
    [fetchRequest release];
    

}
-(IBAction) reduceClicked:(id) sender{
    NSError *error = nil;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber * quantity = [f numberFromString: quantityText.text];
    int q = quantity.intValue;
    q--;
        
    if (q > 0) {
        
        NSString *qText = [NSString stringWithFormat:@"%d",q];
        [quantityText setText:qText];
        quantity = [NSNumber numberWithInt:q];

        NSManagedObjectContext *context = [self managedObjectContext];

        
        //seek for beer
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
        
         NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
            NSLog(@"Hay un erro al hacer fetch de beer para update");
        }
        
        if (!beer) {
            NSLog(@"haciendo insert");
            //Nothing there to update
            [beer setValue:beerName forKey:@"name"];
            [beer setValue:price forKey:@"priceString"];
            
            
            
            NSNumber * priceValue = [f numberFromString: price];
            
            [beer setValue:priceValue forKey:@"priceValue"];
            
            NSLog(@"quantityText.text = %@",quantityText.text);
            
            [beer setValue:quantity forKey:@"quantity"];
            
            [f release];
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        else{
            NSLog(@"haciendo update");
            //Update the object
            [beer setValue:quantity forKey:@"quantity"];
            //Save it
            error = nil;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        
        
        //LOG-SACAR!!
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Beer" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchedObjects) {
            if (![info isDeleted]){
                NSLog(@"Name: %@", [info valueForKey:@"name"]);
                NSLog(@"Price: %@", [info valueForKey:@"priceString"]);
                NSLog(@"Price: %@", [info valueForKey:@"priceValue"]);
                NSLog(@"Quantity: %@", [info valueForKey:@"quantity"]);
            }        }    
        [request release];
        [fetchRequest release];
    }
    else{
        if (q == 0){
            NSString *qText = [NSString stringWithFormat:@"%d",q];
            [quantityText setText:qText];
            quantity = [NSNumber numberWithInt:q];
        }
        NSManagedObjectContext *context = [self managedObjectContext];

        
        //seek for beer
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
        
        NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
            NSLog(@"Hay un erro al hacer fetch de beer para delete");
        }
        
        if (beer) {
            [context deleteObject:beer];
            //Save it
            error = nil;
            if (![context save:&error]) {
                
                 NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        //LOG-SACAR!!
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Beer" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchedObjects) {
            if (![info isDeleted]){
                NSLog(@"Name: %@", [info valueForKey:@"name"]);
                NSLog(@"Price: %@", [info valueForKey:@"priceString"]);
                NSLog(@"Price: %@", [info valueForKey:@"priceValue"]);
                NSLog(@"Quantity: %@", [info valueForKey:@"quantity"]);
            }
        }    
        [request release];
        [fetchRequest release];
        
    }
    
    

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
    
    NSError *error = nil;

 //   NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];  
//    self.image.image = [[UIImage alloc] initWithData:imageData]; 
    NSString *sizeText = [NSString stringWithFormat:@"Size: %@ml",size];
    NSString *abvText = [NSString stringWithFormat:@"Abv: %@%%",abv];
    NSString *priceText = [NSString stringWithFormat:@"S$: %@",price];
    
    [label1 setText:sizeText];
    [label2 setText:abvText];
    [label3 setText:priceText];
    
       
     NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name=%@",beerName]];
    
    NSManagedObject *beer = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (error) {
        //Handle any errors
        NSLog(@"Hay un erro al hacer fetch de beer para update");
    }
    
    if (beer) {
        NSString *qText = [NSString stringWithFormat:@"%@",[beer valueForKey:@"quantity"]];
        [quantityText setText:qText];
    }
    else{
        NSString *qText = [NSString stringWithFormat:@"%d",0];
        [quantityText setText:qText];
    }

//    Codigo para limpiar la base de datos
//    NSFetchRequest * allBeers = [[NSFetchRequest alloc] init];
//    [allBeers setEntity:[NSEntityDescription entityForName:@"Beer" inManagedObjectContext:context]];
//    [allBeers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
//    
//    NSError * error = nil;
//    NSArray * beers = [context executeFetchRequest:allBeers error:&error];
//    [allBeers release];
//    //error handling goes here
//    for (NSManagedObject * beer in beers) {
//        [context deleteObject:beer];
//    }
//    NSError *saveError = nil;
//    [context save:&saveError];
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
    UIImage *imagePlus = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"greenplus" ofType:@"png"]];
    [buttonAdd setImage:imagePlus forState:UIControlStateNormal];
    
    UIImage *imageMinus = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"redminus" ofType:@"png"]];
    [buttonReduce setImage:imageMinus forState:UIControlStateNormal];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
