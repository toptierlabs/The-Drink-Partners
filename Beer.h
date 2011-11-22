//
//  Beer.h
//  TDP
//
//  Created by TopTier on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Beer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * priceValue;
@property (nonatomic, retain) NSString * priceString;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abv;

@end
