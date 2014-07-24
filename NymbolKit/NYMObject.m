//
//  NYMObject.m
//  NymbolKit
//
//  Created by Max Woolf on 18/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import "NYMObject.h"
#import "NymbolKit.h"
#import "NYMResource.h"

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
                if (responseObject[@"latitude"] != [NSNull null] && responseObject[@"longitude"] != [NSNull null]) {
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

- (void)fetchResourcesWithBlock:(void (^)(BOOL, NSError *, NSArray *))block
{
    dispatch_queue_t queue = dispatch_queue_create("nymbolkit_getResources", nil);
    dispatch_async(queue, ^{
        
        NSURLRequest *request = [NymbolKit customBaseRequestWithEndpoint:[NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/assets/%@/resources.json", _collection.pk, self.pk]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *resources = [[NSMutableArray alloc] init];
            for (NSDictionary *resource in responseObject) {
                NYMResource *newResource = [NYMResource new];
                // Only deals with image resource at the moment
                newResource.kind = NYMResourceTypeImage;
                newResource.url = [NSURL URLWithString:resource[@"media"]];
                [resources addObject:newResource];
            }
            block(YES, nil, resources);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(NO, error, nil);
        }];
        [operation start];
    });
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return _location;
}

- (NSString *)title
{
    return self.name;
}

- (MKPinAnnotationView *)pinAnnotationView
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"pin"];
    [pin setPinColor:MKPinAnnotationColorGreen];
    [pin setAnimatesDrop:YES];
    pin.canShowCallout = YES;
    return pin;
}

@end
