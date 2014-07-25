#import "NYMTaxonomy.h"
#import "NymbolKit.h"

@implementation NYMTaxonomy

+ (void)allTaxonomiesForCollection:(NYMCollection *)collection WithBlock:(void (^)(NSArray *, NSError *))block{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allTaxonomies", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/taxonomies.json", collection.pk]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *taxonomies = [[NSMutableArray alloc] init];
            for (NSDictionary *taxonomy in responseObject) {
                NYMTaxonomy *newTaxonomy = [NYMTaxonomy new];
                newTaxonomy.name = taxonomy[@"name"];
                newTaxonomy.pk = taxonomy[@"id"];
                newTaxonomy.collection = collection;
                [taxonomies addObject:newTaxonomy];
                NSMutableArray *tags = [[NSMutableArray alloc] init];
                for (NSString *tag in [taxonomy objectForKey:@"tags"]) {
                    NYMTag *newTag = [NYMTag new];
                    newTag.name = tag;
                    newTag.taxonomy = newTaxonomy;
                    [tags addObject:newTag];
                }
                newTaxonomy.tags = tags;
            }
            block(taxonomies, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}

@end
