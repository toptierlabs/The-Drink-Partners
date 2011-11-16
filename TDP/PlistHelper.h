//
//  PlistHelper.h
//  TDP
//
//  Created by TopTier on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSDictionary *dicTexts;

@interface PlistHelper : NSObject {

}


+(NSString *) readValue:(NSString*) key;
@end
