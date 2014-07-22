#import <Foundation/Foundation.h>

@class NYMObject, NYMTaxonomy;
@interface NYMTag : NSObject

@property (nonatomic) NSString *name;

// Optionally an Object or a Taxonomy
@property (nonatomic) NYMObject *object;
@property (nonatomic) NYMTaxonomy *taxonomy;

@end
