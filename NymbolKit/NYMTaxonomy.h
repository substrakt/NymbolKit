#import <Foundation/Foundation.h>

@interface NYMTaxonomy : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *terms;
@property (nonatomic) NSMutableArray *tags;
@property (nonatomic) NYMCollection *collection;


+ (void)allTaxonomiesForCollection:(NYMCollection *)collection WithBlock:(void (^)(NSArray *taxonomies, NSError *error))block;
@end
