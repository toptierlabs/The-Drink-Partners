//
//  NewsDetailsViewController.h
//  TDP
//
//  Created by fernando colman on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailsViewController : UIViewController{
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *image;
    
    NSString *text;
    NSString *imageURL;
    NSString *newsTitle;
    
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *image;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *newsTitle;



-(void) resetInfo;

@end
 