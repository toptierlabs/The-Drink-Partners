//
//  PlistHelper.m
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlistHelper.h"


@implementation PlistHelper

static NSDictionary *dicTexts;
+(NSString *) readValue:(NSString*) key{
    if (dicTexts == nil) 
    {
        NSString *pathURLs = [[NSBundle mainBundle] pathForResource:@"URLs" ofType:@"plist"];
        dicTexts = [[NSDictionary alloc] initWithContentsOfFile:pathURLs];
    }
    
    return [dicTexts objectForKey:key];
    
}

@end
