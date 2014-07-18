#import <Foundation/Foundation.h>

@interface NYMCollection : NSObject

/**
 *  Fetch all collections asyncronously
 *
 *  @param block Completion block to run after fetching collections.
 *  One or other of collections or error will be populated on completion.
 */
+ (void)allCollectionsWithBlock:(void (^)(NSArray *collections, NSError *error))block;

@end
