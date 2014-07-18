#import "NYMCollection.h"
#import "NymbolKit.h"

@implementation NYMCollection

+ (void)allCollectionsWithBlock:(void (^)(NSArray *, NSError *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allCollections", nil);
    dispatch_async(queue, ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[NymbolKit authHeaderKey] forHTTPHeaderField:@"Authorization"];
        
        [manager GET:@"http://nymbol.co.uk/api/manager/collection.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
    });
}

@end
