//
//  Beer.h
//  TDP
//
//  Created by fernando colman on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Beer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * priceValue;
@property (nonatomic, retain) NSString * abv;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * priceString;

@end
