//
//  NYMObject.h
//  NymbolKit
//
//  Created by Max Woolf on 18/07/2014.
//  Copyright (c) 2014 Substrakt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NYMCollection.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "NYMTag.h"
#import "NYMLink.h"
#import <MapKit/MapKit.h>

@interface NYMObject : NSObject <MKAnnotation>

@property (nonatomic) NSString *name;
@property (nonatomic) NYMCollection *collection;
@property (nonatomic) NSString *pk;
@property (nonatomic) int status;
@property (nonatomic) int curator;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *thumbnailPath;
@property (nonatomic) NSURL *shareUrl;
@property (nonatomic) NSMutableArray /*<NYMTag *>*/ *tags;
@property (nonatomic) NSMutableArray /*<NYMLink *>*/ *links;


@property (nonatomic, readonly) BOOL thumbnailIsLoaded;
@property (nonatomic) BOOL dataIsLoaded;

+ (void)allObjectsForCollection:(NYMCollection *)collection WithBlock:(void (^)(NSArray *objects, NSError *error))block;

- (void)fetchThumbnailWithBlock:(void (^)(UIImage *thumbnail, NSError *error))block;

- (void)fetchDataWithBlock:(void (^)(BOOL succeeded, NSError *error, NYMObject *object))block;
- (MKPinAnnotationView *)pinAnnotationView;
@end
