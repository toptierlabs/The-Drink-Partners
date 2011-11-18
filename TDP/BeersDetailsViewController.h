//
//  BeersDetailsViewController.h
//  TDP
//
//  Created by fernando colman on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeersDetailsViewController : UIViewController{
    NSString *text;
    
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *image;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    
}
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UILabel *label2;
@property (nonatomic, retain) UILabel *label3;

-(void) resetInfo;

@end
