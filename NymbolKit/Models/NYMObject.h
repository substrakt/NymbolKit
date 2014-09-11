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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NYMCollection *collection;
@property (nonatomic, retain) NSString *pk;
@property (nonatomic) int status;
@property (nonatomic) int curator;
@property (nonatomic, retain) NSArray *resources;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *thumbnailPath;
@property (nonatomic, retain) NSURL *shareUrl;
@property (nonatomic, retain) NSMutableArray /*<NYMTag *>*/ *tags;
@property (nonatomic, retain) NSMutableArray /*<NYMLink *>*/ *links;


@property (nonatomic, readonly) BOOL thumbnailIsLoaded;
@property (nonatomic) BOOL dataIsLoaded;

+ (void)allObjectsForCollection:(NYMCollection *)collection WithBlock:(void (^)(NSArray *objects, NSError *error))block;
+ (void)objectWithPk:(NSString *)primaryKey inCollection:(NYMCollection *)collection WithBlock:(void (^)(NYMObject *object, NSError *error))block;

- (void)fetchDataWithBlock:(void (^)(BOOL succeeded, NSError *error, NYMObject *object))block;
- (void)fetchResourcesWithBlock:(void (^)(BOOL succeeded, NSError *error, NSArray *resources))block;

- (MKPinAnnotationView *)pinAnnotationView;
@end
