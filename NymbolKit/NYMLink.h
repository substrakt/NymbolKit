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

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NYMObject *object;

@end
