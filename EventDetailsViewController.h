//
//  EventDetailsViewController.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventDetailsViewController : UIViewController {
    NSArray *images;
    NSString *text;
    
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *image1;
    IBOutlet UIImageView *image2;
    IBOutlet UIImageView *image3;
    IBOutlet UIImageView *image4;
    IBOutlet UIImageView *image5;
    
//    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *image1;
@property (nonatomic, retain) UIImageView *image2;
@property (nonatomic, retain) UIImageView *image3;
@property (nonatomic, retain) UIImageView *image4;
@property (nonatomic, retain) UIImageView *image5;

//@property (nonatomic, retain) UIScrollView *scrollView;

@end
