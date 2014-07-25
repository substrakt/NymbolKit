#import <Foundation/Foundation.h>

@class NYMObject, NYMTaxonomy;
@interface NYMTag : NSObject

@property (nonatomic, retain) NSString *name;

// Optionally an Object or a Taxonomy
@property (nonatomic, retain) NYMObject *object;
@property (nonatomic, retain) NYMTaxonomy *taxonomy;

@end
