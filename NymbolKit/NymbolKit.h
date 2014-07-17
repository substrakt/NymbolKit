#import <Foundation/Foundation.h>
#import "CocoaSecurity.h"

/**
 *  Base class used for authentication
 */
@interface NymbolKit : NSObject

/**
 *  Method to be called before any Nymbol API calls can be made.
 *  It stores the key and secret key in the NSUserDefaults to be used later.
 *
 *  @param key       The key from your Nymbol dashboard
 *  @param secretKey The secret key from your Nymbol dashboard
 */
+ (void)initializeSessionWithKey:(NSString *)key secretKey:(NSString *)secretKey;


/**
 *  Returns the currently used API key
 *
 *  @return The API key
 */
+ (NSString *)currentKey;

/**
 *  Returns the currently used secret
 *
 *  @return The current secret API key
 */
+ (NSString *)currentSecret;

/**
 *  Returns the authorization key to use in the request headers
 *
 *  @return The MD5 string required for authorization
 */
+ (NSString *)authHeaderKey;

@end
