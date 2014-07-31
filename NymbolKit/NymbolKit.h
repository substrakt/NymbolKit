#import <Foundation/Foundation.h>
#import "CocoaSecurity.h"
#import "NYMCollection.h"
#import "NYMObject.h"
#import "NYMTag.h"
#import "NYMLink.h"
#import "NYMTaxonomy.h"
#import "NYMTaxonomyTerm.h"

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
+ (void)initializeSessionWithKey:(NSString *)key secretKey:(NSString *)secretKey appIdentifier:(NSString *)identifier;


/**
 *  Returns the currently used API key
 *
 *  @return The API key
 */
+ (NSString *)currentKeyForAppIdentifier:(NSString *)identifier;

/**
 *  Returns the currently used secret
 *
 *  @return The current secret API key
 */
+ (NSString *)currentSecretForAppIdentifier:(NSString *)identifier;

/**
 *  Returns the authorization key to use in the request headers
 *
 *  @return The MD5 string required for authorization
 */
+ (NSString *)authHeaderKeyForAppIdentifier:(NSString *)identifier;

+ (NSURLRequest *)baseRequestWithEndpoint:(NSString *)endpoint;
+ (NSURLRequest *)customBaseRequestWithEndpoint:(NSString *)endpoint;

@end
