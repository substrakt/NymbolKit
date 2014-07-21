//
//  NYMTag.h
//  NymbolKit
//
//  Created by Max Woolf on 21/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYMObject.h"

@interface NYMTag : NSObject

@property (nonatomic) NYMObject *object;
@property (nonatomic) NSString *name;

@end
