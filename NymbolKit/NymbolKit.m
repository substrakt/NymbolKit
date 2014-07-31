#import "NymbolKit.h"
#import <Security/Security.h>

@implementation NymbolKit

+ (void)initializeSessionWithKey:(NSString *)key secretKey:(NSString *)secretKey appIdentifier:(NSString *)identifier
{
    [[NSUserDefaults standardUserDefaults] setValue:key forKey:@"nymbol_key"];
    [[NSUserDefaults standardUserDefaults] setValue:secretKey forKey:@"nymbol_secret"];
    [[NSUserDefaults standardUserDefaults] setValue:identifier forKeyPath:@"nymbol_identifier"];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secretData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *keyDict = @{
                              (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                              (__bridge id)kSecAttrService: @"nymbolKey",
                              (__bridge id)kSecValueData: keyData,
                              (__bridge id)kSecAttrAccount: identifier
    };
    NSDictionary *secretDict = @{
                              (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                              (__bridge id)kSecAttrService: @"nymbolSecret",
                              (__bridge id)kSecValueData: secretData,
                              (__bridge id)kSecAttrAccount: identifier
                              };
    
    OSStatus keyStatus = SecItemAdd((__bridge CFDictionaryRef) keyDict, NULL);
    OSStatus secretStatus = SecItemAdd((__bridge CFDictionaryRef) secretDict, NULL);
    if (keyStatus != 0 || secretStatus != 0) {
        NSDictionary *removalKeyDict = @{
                                  (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                  (__bridge id)kSecAttrService: @"nymbolKey",
                                  (__bridge id)kSecAttrAccount: identifier
                                  };
        SecItemUpdate((__bridge CFDictionaryRef)(removalKeyDict), (__bridge CFDictionaryRef)(@{(__bridge id)kSecValueData: keyData}));
        
        NSDictionary *removalSecretDict = @{
                                         (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                         (__bridge id)kSecAttrService: @"nymbolSecret",
                                         (__bridge id)kSecAttrAccount: identifier
                                         };
        SecItemUpdate((__bridge CFDictionaryRef)(removalSecretDict), (__bridge CFDictionaryRef)(@{(__bridge id)kSecValueData: secretData}));
    }
}

+ (NSString *)currentKeyForAppIdentifier:(NSString *)identifier
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"nymbolKey",
                            (__bridge id)kSecAttrAccount: identifier,
                            (__bridge id)kSecReturnData: @YES
    };
    CFDataRef attributes;
    OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&attributes);
    NSLog(@"%i", (int)resultStatus);
    NSData *passDat = (__bridge_transfer NSData *)attributes;
    NSString *key = [[NSString alloc] initWithData:passDat encoding:NSUTF8StringEncoding];
    return key;
}

+ (NSString *)currentSecretForAppIdentifier:(NSString *)identifier
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"nymbolSecret",
                            (__bridge id)kSecAttrAccount: identifier,
                            (__bridge id)kSecReturnData: @YES
                            };
    CFDataRef attributes;
    OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&attributes);
    NSLog(@"%i", (int)resultStatus);
    NSData *passDat = (__bridge_transfer NSData *)attributes;
    NSString *key = [[NSString alloc] initWithData:passDat encoding:NSUTF8StringEncoding];
    return key;
}

+ (NSString *)authHeaderKeyForAppIdentifier:(NSString *)identifier
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [NymbolKit currentKeyForAppIdentifier:identifier], [NymbolKit currentSecretForAppIdentifier:identifier]];
    return [[CocoaSecurity md5:authString] hexLower];
}

+ (NSURLRequest *)baseRequestWithEndpoint:(NSString *)endpoint
{
    NSString *urlString = [NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/%@.json", endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:[NymbolKit authHeaderKeyForAppIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:@"nymbol_identifier"]] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%@", [UIDevice currentDevice].identifierForVendor] forHTTPHeaderField:@"X-Device"];
    [request setValue:@"ios" forHTTPHeaderField:@"X-Platform"];
    return request;
}

+ (NSURLRequest *)customBaseRequestWithEndpoint:(NSString *)endpoint
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request setValue:[NymbolKit authHeaderKeyForAppIdentifier:@"com.example.example"] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%@", [UIDevice currentDevice].identifierForVendor] forHTTPHeaderField:@"X-Device"];
    [request setValue:@"ios" forHTTPHeaderField:@"X-Platform"];
    return request;
}


@end
