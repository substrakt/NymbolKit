//
//  NYMObject.h
//  NymbolKit
//
//  Created by Max Woolf on 18/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NYMObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) int status;
@property (nonatomic) int curator;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) NSString *description;
@end
