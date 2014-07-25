//
//  NYMLink.h
//  NymbolKit
//
//  Created by Max Woolf on 21/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NYMObject;
@interface NYMLink : NSObject

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NYMObject *object;

@end
