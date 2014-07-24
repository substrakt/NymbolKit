#import "NYMTaxonomyTerm.h"
#import "NymbolKit.h"
#import "NYMTaxonomy.h"
@implementation NYMTaxonomyTerm
+ (void)allTermsForTaxonomy:(NYMTaxonomy *)taxonomy WithBlock:(void (^)(NSArray *, NSError *))block {
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allTaxonomyTerms", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/taxonomies/%@/terms.json", taxonomy.collection.pk, taxonomy.pk]];
        NSLog(@"%@", request);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *terms = [[NSMutableArray alloc] init];
            for (NSDictionary *term in responseObject) {
                NYMTaxonomyTerm *newTerm = [NYMTaxonomyTerm new];
                newTerm.name = term[@"name"];
                newTerm.pk = term[@"id"];
                newTerm.shareURL = [NSURL URLWithString:term[@"share_url"]];
                newTerm.taxonomy = taxonomy;
                [terms addObject:newTerm];
            }
            block(terms, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}


- (void)allObjectsWithBlock:(void (^)(NSArray *, NSError *))block {
    
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allTaxonomyTerms", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/assets.json?taxonomy[%@]=%@", _taxonomy.collection.pk, _taxonomy.pk, _pk]];
        NSLog(@"%@", request);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            for (NSDictionary *object in responseObject) {
                NYMObject *newObject = [NYMObject new];
                newObject.pk = [object[@"id"] stringValue];
                newObject.name = object[@"name"];
                [objects addObject:newObject];
            }
            block(objects, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}
@end
