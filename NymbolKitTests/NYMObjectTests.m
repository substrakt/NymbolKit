#import "Kiwi.h"
#import "NYMObject.h"
#import "Nocilla.h"
#import "NYMLink.h"

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
        
    });
    
    context(@"with ID 4 and a collection set", ^{
        beforeEach(^{
            object.pk = @"10";
            NYMCollection __block *collection = [NYMCollection new];
            collection.pk = @"1";
            object.collection = collection;
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