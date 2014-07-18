#import "Kiwi.h"
#import "NYMCollection.h"
#import "NymbolKit.h"
#import "Nocilla.h"

SPEC_BEGIN(NYMCollectionSpec)

beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterAll(^{
    [[LSNocilla sharedInstance] stop];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});
beforeEach(^{
    [NymbolKit initializeSessionWithKey:@"thisisinvalid" secretKey:@"soisthis"];
});

describe(@"Fetchng a single collection by UID", ^{
    
    context(@"with valid credentials", ^{
        
        beforeEach(^{
            [NymbolKit initializeSessionWithKey:@"NsgWPgQ5RXVh67NjX2" secretKey:@"J4zakHEFs89yeE29WeR6KbJZncuLtXZP"];
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/8E91.json").
            withHeaders(@{ @"Authorization": @"084fd67c31f251946091d6c7923372a0" }).
            andReturn(200).
            withHeaders(@{@"Content-Type": @"application/json"}).
            withBody(@"{\"id\": 43, \"name\": \"Game of Thrones Characters\", \"uid\": \"8E91\"}");
        });

        it(@"should give a single NYMCollection object.", ^{
            
            NSError __block *parentError = nil;
            NYMCollection __block *parentCollections = nil;
            [NYMCollection collectionWithUID:@"8E91" block:^(NYMCollection *collection, NSError *error) {
                parentError = error;
                parentCollections = collection;
            }];
            
            [[expectFutureValue(parentError) shouldEventually] beNil];
            [[expectFutureValue([parentCollections name]) shouldEventually] equal:@"Game of Thrones Characters"];
        });
    });
    
});

describe(@"Fetching all collections", ^{
   
    context(@"with valid credentials", ^{
        beforeEach(^{
            [NymbolKit initializeSessionWithKey:@"NsgWPgQ5RXVh67NjX2" secretKey:@"J4zakHEFs89yeE29WeR6KbJZncuLtXZP"];
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection.json").
            withHeaders(@{ @"Authorization": @"084fd67c31f251946091d6c7923372a0" }).
            andReturn(200).
            withHeaders(@{@"Content-Type": @"application/json"}).
            withBody(@"[{\"id\": 43, \"name\": \"Game of Thrones Characters\", \"uid\": \"8E91\"}]");
        });

        it(@"should give an NSArray of NYMCollection objects.", ^{
            
            NSError __block *parentError = nil;
            NSArray __block *parentCollections = nil;
            
            [NYMCollection allCollectionsWithBlock:^(NSArray *collections, NSError *error) {
                parentError = error;
                parentCollections = collections;
            }];

            [[expectFutureValue(parentCollections) shouldNotEventually] beEmpty];
            [[expectFutureValue(parentError) shouldEventually] beNil];
            [[expectFutureValue([[parentCollections objectAtIndex:0] name]) shouldEventually] equal:@"Game of Thrones Characters"];
        });
    });
    
    context(@"with invalid credentials", ^{
        

        it(@"should give an error.", ^{
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection.json").
            andReturn(403);
            NSError __block *parentError = nil;
            NSArray __block *parentCollections = nil;

            [NYMCollection allCollectionsWithBlock:^(NSArray *collections, NSError *error) {
                parentError = error;
                parentCollections = collections;
            }];
            [[expectFutureValue(parentError) shouldEventually] beKindOfClass:[NSError class]];
            [[expectFutureValue(parentError) shouldNotEventually] beNil];
            [[expectFutureValue(parentCollections) shouldEventually] beNil];
        });
    });
    
});

SPEC_END