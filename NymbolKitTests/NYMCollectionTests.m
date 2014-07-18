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

describe(@"Fetching all collections", ^{
   
    context(@"with valid credentials", ^{
        beforeEach(^{
            [NymbolKit initializeSessionWithKey:@"" secretKey:@""];
        });
        it(@"should give an NSArray of NYMCollection objects.", ^{
            
        });
        
    });
    
    context(@"with invalid credentials", ^{
        
        beforeEach(^{
            [NymbolKit initializeSessionWithKey:@"thisisinvalid" secretKey:@"soisthis"];
        });

        it(@"should give an error.", ^{
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection.json").
            andReturn(403);
            NSError __block *parentError = nil;
            [NYMCollection allCollectionsWithBlock:^(NSArray *collections, NSError *error) {
                parentError = error;
            }];
            [[expectFutureValue(parentError) shouldEventually] beKindOfClass:[NSError class]];
            [[expectFutureValue(parentError) shouldNotEventually] beNil];
        });
    });
    
});

SPEC_END