//
//  NYMObject.m
//  NymbolKit
//
//  Created by Max Woolf on 18/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import "NYMObject.h"

@implementation NYMObject


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
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *imageURLString = [NSString stringWithFormat:@"http://nymbol.co.uk/api/manager/collection/%@/assets/%i.json", _collection.pk, self.pk];
            
            [manager GET:imageURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                _location = CLLocationCoordinate2DMake([responseObject[@"latitude"] doubleValue], [responseObject[@"longitude"] doubleValue]);
                _description = responseObject[@"description"];
                _dataIsLoaded = YES;
                _shareUrl = [NSURL URLWithString:responseObject[@"share_url"]];
                block(YES, nil, self);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block(NO, error, nil);
            }];
        });
    }
}

@end
