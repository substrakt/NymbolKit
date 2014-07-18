#import "NYMCollection.h"
#import "NymbolKit.h"
#import "NYMObject.h"

@implementation NYMCollection

+ (void)allCollectionsWithBlock:(void (^)(NSArray *, NSError *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allCollections", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit baseRequestWithEndpoint:@"collection"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *collections = [[NSMutableArray alloc] init];
            for (NSDictionary *collection in responseObject) {
                NYMCollection *newCollection = [NYMCollection new];
                NSLog(@"%@", collection[@"name"]);
                newCollection.name = collection[@"name"];
                newCollection.uid = collection[@"uid"];
                newCollection.pk = collection[@"pk"];
                [collections addObject:newCollection];
            }
            block(collections, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}

+ (void)collectionWithUID:(NSString *)uid block:(void (^)(NYMCollection *, NSError *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_oneCollection", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit baseRequestWithEndpoint:[NSString stringWithFormat:@"collection/%@", uid]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NYMCollection *newCollection = [NYMCollection new];
            newCollection.name = responseObject[@"name"];
            newCollection.uid = responseObject[@"uid"];
            newCollection.pk = responseObject[@"id"];
            block(newCollection, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}

- (void)fetchObjectsIfNeededWithBlock:(void (^)(NSArray *, NSError *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_fetchObjects", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit baseRequestWithEndpoint:[NSString stringWithFormat:@"collection/%@/assets", self.pk]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *assets = [[NSMutableArray alloc] init];
            for (NSDictionary *object in responseObject) {
                NYMObject *newObject = [NYMObject new];
                
                // TODO: Set attributes
                [assets addObject:newObject];
            }
            block(assets, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}

@end
