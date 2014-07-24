#import "Kiwi.h"
#import "NYMObject.h"
#import "Nocilla.h"
#import "NYMLink.h"
#import "NYMResource.h"
#import <MapKit/MapKit.h>

SPEC_BEGIN(NYMObjectSpec)


describe(@"An object", ^{
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    NYMObject __block *object;
    beforeEach(^{
        object = [NYMObject new];
        stubRequest(@"GET", @"http://gsp1.apple.com/pep/gcc");
    });
    context(@"which has been newly created", ^{
        
        
        it(@"should have nil for the name", ^{
            [[object name] shouldBeNil];
        });
        
        it(@"should not be loaded.", ^{
            [[theValue([object dataIsLoaded]) should] beNo];
        });
        
        it(@"should conform to the MKAnnotation protocol.", ^{
            [[object should] conformToProtocol:@protocol(MKAnnotation)];
        });
        
    });
    
    context(@"with ID 4 and a collection set", ^{
        NYMCollection __block *collection;
        beforeEach(^{
            object.pk = @"10";
            collection = [NYMCollection new];
            collection.pk = @"1";
            object.collection = collection;
        });
        
        context(@"where we want to get all of the associated objects", ^{
            NSArray __block *parentObjects;
            beforeEach(^{
                
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets.json").
                andReturn(200).
                withHeaders(@{@"Content-Type": @"application/json"}).
                withBody(@"[{\"name\": \"a\", \"id\": 4}]");

                [NYMObject allObjectsForCollection:collection WithBlock:^(NSArray *objects, NSError *error) {
                    parentObjects = objects;
                }];
            });
            
            it(@"should have an object.", ^{
                [[expectFutureValue(theValue(parentObjects.count)) shouldEventually] equal:1 withDelta:0];
            });
        });

        context(@"where the successful response has tags", ^{
            beforeEach(^{
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10.json").
                andReturn(200).
                withHeaders(@{@"Content-Type": @"application/json"}).
                withBody(@"{\"tags\": [\"tag-1\", \"tag-2\"]}");
                [object fetchDataWithBlock:^(BOOL succeeded, NSError *error, NYMObject *object) {}];
            });
            
            it(@"should create two associated tag objects.", ^{
                [[expectFutureValue(theValue(object.tags.count)) shouldEventually] equal:2 withDelta:0];
            });
        });
        
        context(@"where the successful response has links", ^{
            beforeEach(^{
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10.json").
                andReturn(200).
                withHeaders(@{@"Content-Type": @"application/json"}).
                withBody(@"{\"links\": [{ \"url\": \"http://url.com\", \"title\": \"A nice website\" }]}");
                [object fetchDataWithBlock:^(BOOL succeeded, NSError *error, NYMObject *object) {}];
            });
            
            it(@"should create two associated Link objects.", ^{
                [[expectFutureValue(theValue(object.links.count)) shouldEventually] equal:1 withDelta:0];
                [[expectFutureValue([(NYMLink *)object.links[0] url]) shouldEventually] equal:[NSURL URLWithString:@"http://url.com"]];
                [[expectFutureValue([(NYMLink *)object.links[0] title]) shouldEventually] equal:@"A nice website"];
            });
        });
        
        context(@"where the response is succesful but the object does not have a location", ^{
            beforeEach(^{
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10.json").
                andReturn(200).
                withHeaders(@{@"Content-Type": @"application/json"}).
                withBody(@"{\"name\": \"abc\", \"id\": 4}");
                
                [object fetchDataWithBlock:^(BOOL succeeded, NSError *error, NYMObject *object) {}];
            });
            
            it(@"should have a 0 lat/long location.", ^{

                [[expectFutureValue(theValue(object.location.latitude)) shouldEventually] equal:0 withDelta:0];
            });
        });
        
        context(@"where the response is successful from the server", ^{
            beforeEach(^{
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10.json").
                andReturn(200).
                withHeaders(@{@"Content-Type": @"application/json"}).
                withBody(@"{\"longitude\": 100, \"latitude\": 200, \"description\": \"desc\", \"share_url\": \"http://google.com\"}");
                
                [object fetchDataWithBlock:^(BOOL succeeded, NSError *error, NYMObject *object) {}];
            });
            
            it(@"should eventually set the dataIsLoaded to True", ^{
                [[expectFutureValue(theValue([object dataIsLoaded])) shouldEventually] equal:theValue(YES)];
            });
            
            it(@"should set the location of the object.", ^{
                [[expectFutureValue(theValue(object.location.latitude)) shouldEventually] equal:200.0
                                                                                      withDelta:0];
                [[expectFutureValue(theValue(object.location.longitude)) shouldEventually] equal:100.0
                                                                                      withDelta:0];
            });
            
            it(@"should set the description of the object.", ^{
                [[expectFutureValue(object.description) shouldEventually] equal:@"desc"];
            });
            
            it(@"should set the share URL.", ^{
                [[expectFutureValue(object.shareUrl) shouldEventually] equal:[NSURL URLWithString:@"http://google.com"]];
            });
            
            context(@"and I request the resources for the object", ^{
                NSArray __block *parentResources;
                beforeEach(^{
                    
                    [object fetchResourcesWithBlock:^(BOOL succeeded, NSError *error, NSArray *resources) {
                        parentResources = resources;
                    }];
                    
                    stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10/resources.json").
                    andReturn(200).
                    withHeaders(@{@"Content-Type": @"application/json"}).
                    withBody(@"[{\"mimetype\": null, \"kind\": \"image\", \"guest\": null, \"title\": \"First picture\", \"url\": null, \"media\": \"https://nymbol.co.uk/media/collections/hQPE/images/9xc0LfF/3b9f00b3-ebd5-47b9-ba47-1a3d3d887b8f\", \"curator\": 85, \"approved\": true, \"ordering\": 0, \"featured\": true, \"fields\": {}, \"date\": \"2014-07-23 10:33:32\", \"id\": 10046, \"description\": \"\"}, {\"mimetype\": \"image/jpeg\", \"kind\": \"image\", \"guest\": null, \"title\": \"Oh no\", \"url\": null, \"media\": \"https://nymbol.co.uk/media/collections/hQPE/images/9xc0LfF/ee3c19b3-1e6f-4e25-a09a-c0b3710ab3a9.jpg\", \"description\": \"\", \"curator\": 85, \"approved\": true, \"ordering\": 2, \"featured\": false, \"fields\": {}, \"date\": \"2014-07-24 13:37:55\", \"id\": 10048, \"name\": \"Oh no\"}]");
                });
                
                it(@"should create some NYMResource objects.", ^{
                    [[expectFutureValue(theValue(parentResources.count)) shouldEventually] equal:2 withDelta:0];
                });
                
                it(@"should create a NYMResource with kind image.", ^{
                    [[expectFutureValue(theValue([(NYMResource *)[parentResources objectAtIndex:0] kind])) shouldEventually] equal:theValue(NYMResourceTypeImage)];
                });
                
                it(@"should assign the URL.", ^{
                    [[expectFutureValue([(NYMResource *)[parentResources objectAtIndex:0] url]) shouldEventually] equal:[NSURL URLWithString:@"https://nymbol.co.uk/media/collections/hQPE/images/9xc0LfF/3b9f00b3-ebd5-47b9-ba47-1a3d3d887b8f"]];
                });
            });
        });
        
        context(@"where the response is unsuccessful from the server", ^{
            beforeEach(^{
                stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/assets/10.json").
                andReturn(302);
            });
            
            it(@"should return an error.", ^{
                NSError __block *parentError;
                [object fetchDataWithBlock:^(BOOL succeeded, NSError *error, NYMObject *object) {
                    parentError = error;
                }];
                [[expectFutureValue(parentError) shouldNotEventually] beNil];
            });
        });
    });
    
    context(@"where the name is 'Statue of Arya Stark", ^{
        NYMObject __block *object;
        beforeEach(^{
            object = [NYMObject new];
            object.name = @"Statue of Arya Stark";
        });
        
        it(@"should have a name.", ^{
            [[[object name] should] equal:@"Statue of Arya Stark"];
        });
    });
    
});

SPEC_END