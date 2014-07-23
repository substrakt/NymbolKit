//
//  NYMTaxonomyTerm.h
//  NymbolKit
//
//  Created by Max Woolf on 23/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//
@class NYMTaxonomy;
#import <Foundation/Foundation.h>

@interface NYMTaxonomyTerm : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *shareURL;
@property (nonatomic) NYMTaxonomy *taxonomy;

+ (void)allTermsForTaxonomy:(NYMTaxonomy *)taxonomy WithBlock:(void (^)(NSArray *terms, NSError *error))block;
@end
