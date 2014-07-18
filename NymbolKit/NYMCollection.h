#import <Foundation/Foundation.h>

@interface NYMCollection : NSObject

/**
 *  NSArray of NYMObjects
 */
@property (nonatomic) NSArray *objects;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *pk;

/**
 *  Fetch all collections asyncronously
 *
 *  @param block Completion block to run after fetching collections.
 *  One or other of collections or error will be populated on completion.
 */
+ (void)allCollectionsWithBlock:(void (^)(NSArray *collections, NSError *error))block;

/**
 *  Fetch one collection asyncronously
 *
 *  @param block Completion block to run after fetching collections.
 *  One or other of collections or error will be populated on completion.
 */
+ (void)collectionWithUID:(NSString *)uid block:(void (^)(NYMCollection *collection, NSError *error))block;


- (void)fetchObjectsIfNeededWithBlock:(void (^)(NSArray *objects, NSError *error))block;
@end
