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

@synthesize textView,image,label1,label2,label3,quantityText;
@synthesize size,abv,price,text,imageURL,beerName;
@synthesize managedObjectContext,fetchedResultsController;
@synthesize buttonAdd, buttonReduce;

AsyncImageView* asyncImage;

UIImage *scaleAndRotateImage2(UIImage *image,int kMaxResolution)  
{  
    
    CGImageRef imgRef = image.CGImage;  
    
    CGFloat width = CGImageGetWidth(imgRef);  
    CGFloat height = CGImageGetHeight(imgRef);  
    
    CGAffineTransform transform = CGAffineTransformIdentity;  
    CGRect bounds = CGRectMake(0, 0, width, height);  
    if (width > kMaxResolution || height > kMaxResolution) {  
        CGFloat ratio = width/height;  
        if (ratio > 1) {  
            bounds.size.width = kMaxResolution;  
            bounds.size.height = bounds.size.width / ratio;  
        }  
        else {  
            bounds.size.height = kMaxResolution;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = image.imageOrientation;  
    switch(orient) {  
            
        case UIImageOrientationUp: //EXIF = 1  
            transform = CGAffineTransformIdentity;  
            break;  
            
        case UIImageOrientationUpMirrored: //EXIF = 2  
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            break;  
            
        case UIImageOrientationDown: //EXIF = 3  
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
            transform = CGAffineTransformRotate(transform, M_PI);  
            break;  
            
        case UIImageOrientationDownMirrored: //EXIF = 4  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
            transform = CGAffineTransformScale(transform, 1.0, -1.0);  
            break;  
            
        case UIImageOrientationLeftMirrored: //EXIF = 5  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationLeft: //EXIF = 6  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRightMirrored: //EXIF = 7  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRight: //EXIF = 8  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        default:  
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
            
    }  
    
    UIGraphicsBeginImageContext(bounds.size);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    }  
    else {  
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    }  
    
    CGContextConcatCTM(context, transform);  
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return imageCopy;  
} 



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
    
    [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue =qText;
    
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
            NSLog(@"abv: %@", [info valueForKey:@"abv"]);
            NSLog(@"size: %@", [info valueForKey:@"size"]);
            NSLog(@"Quantity: %@", [info valueForKey:@"quantity"]);
            NSLog(@"text: %@", [info valueForKey:@"text"]);
            NSLog(@"ImageURL: %@", [info valueForKey:@"imageURL"]);
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
        
         [(UIViewController *)[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue =qText;

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
        
        if (beer) {

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
    


 //   NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];  
//    self.image.image = [[UIImage alloc] initWithData:imageData]; 
    NSString *sizeText = [NSString stringWithFormat:@"Size: %@ml",size];
    NSString *abvText = [NSString stringWithFormat:@"Abv: %@%%",abv];
    NSString *priceText = [NSString stringWithFormat:@"S$: %@",price];
    
    [label1 setText:sizeText];
    [label2 setText:abvText];
    [label3 setText:priceText];
    
       
         
//    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];  
//    UIImage * imageAux = [[UIImage alloc] initWithData:imageData]; 
//    image.contentMode = UIViewContentModeScaleAspectFit;
//    [image setImage:scaleAndRotateImage(imageAux,120)];
    
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
