//
//  NymbolKit.m
//  NymbolKit
//
//  Created by Max Woolf on 15/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import "NymbolKit.h"

@implementation NymbolKit

+ (void)initializeSessionWithKey:(NSString *)key secretKey:(NSString *)secretKey
{
    [[NSUserDefaults standardUserDefaults] setValue:key forKey:@"nymbol_key"];
    [[NSUserDefaults standardUserDefaults] setValue:secretKey forKey:@"nymbol_secret"];
}

+ (NSString *)currentKey
{
    return @"";
}

+ (NSString *)currentSecret
{
    return @"";
}

@end
