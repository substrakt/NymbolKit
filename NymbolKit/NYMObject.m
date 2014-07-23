//
//  NYMObject.m
//  NymbolKit
//
//  Created by Max Woolf on 18/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import "NYMObject.h"
#import "NymbolKit.h"

@implementation NYMObject

+ (void)allObjectsForCollection:(NYMCollection *)collection WithBlock:(void (^)(NSArray *, NSError *))block {
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_allObjectsCollection", nil);
    dispatch_async(queue, ^{
        NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/assets.json", collection.pk]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            for (NSDictionary *object in responseObject) {
                NYMObject *newObject = [NYMObject new];
                newObject.name = object[@"name"];
                newObject.pk = [object[@"id"] stringValue];
                newObject.dataIsLoaded = NO;
                newObject.collection = collection;
                [objects addObject:newObject];
            }
            block(objects, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
        [operation start];
    });
}

// Looks like thumbnail is missing. Will need to talk to Mark about this.
- (void)fetchThumbnailWithBlock:(void (^)(UIImage *, NSError *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_getThumbnail", nil);
    dispatch_async(queue, ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *imageURLString = [NSString stringWithFormat:@"https://nymbol.co.uk%@", self.thumbnailPath];
        [manager GET:imageURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
    });
}

- (void)fetchDataWithBlock:(void (^)(BOOL, NSError *, NYMObject *))block
{
    if (_dataIsLoaded) {
        block(YES, nil, self);
    } else {
        dispatch_queue_t queue = dispatch_queue_create("nymbolkit_getData", nil);
        dispatch_async(queue, ^{
            _tags = [[NSMutableArray alloc] init];
            _links = [[NSMutableArray alloc] init];

            NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/assets/%@.json", _collection.pk, self.pk]];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject[@"latitude"] && responseObject[@"longitude"]) {
                    _location = CLLocationCoordinate2DMake([responseObject[@"latitude"] doubleValue], [responseObject[@"longitude"] doubleValue]);
                }
                
                _description = responseObject[@"description"];
                _dataIsLoaded = YES;
                _shareUrl = [NSURL URLWithString:responseObject[@"share_url"]];
                for (NSString *tag in responseObject[@"tags"]) {
                    NYMTag *newTag = [NYMTag new];
                    newTag.name = tag;
                    newTag.object = self;
                    [_tags addObject:self];
                }
                
                for (NSDictionary *link in responseObject[@"links"]) {
                    NSLog(@"%@", link);
                    NYMLink *newLink = [NYMLink new];
                    newLink.title = link[@"title"];
                    newLink.url = [NSURL URLWithString:link[@"url"]];
                    newLink.object = self;
                    [_links addObject:newLink];
                }
                block(YES, nil, self);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block(NO, error, nil);
            }];
            [operation start];
        });
    }
}
@end
