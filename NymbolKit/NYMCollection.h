#import <Foundation/Foundation.h>

@interface NYMCollection : NSObject

+ (void)allCollectionsWithBlock:(void (^)(NSArray *collections, NSError *error))block;

@end
