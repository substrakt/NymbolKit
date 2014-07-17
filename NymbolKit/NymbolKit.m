#import "NymbolKit.h"

@implementation NymbolKit

+ (void)initializeSessionWithKey:(NSString *)key secretKey:(NSString *)secretKey
{
    [[NSUserDefaults standardUserDefaults] setValue:key forKey:@"nymbol_key"];
    [[NSUserDefaults standardUserDefaults] setValue:secretKey forKey:@"nymbol_secret"];
}

+ (NSString *)currentKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"nymbol_key"];
}

+ (NSString *)currentSecret
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"nymbol_secret"];
}

+ (NSString *)authHeaderKey
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [NymbolKit currentKey], [NymbolKit currentSecret]];
    return [[CocoaSecurity md5:authString] hexLower];
}

@end
