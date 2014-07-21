#import "Kiwi.h"
#import "NymbolKit.h"
#import "Nocilla.h"


SPEC_BEGIN(NymbolKitSpec)
beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterAll(^{
    [[LSNocilla sharedInstance] stop];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});
describe(@"The login manager", ^{
    
    context(@"when any key and secret are inputted", ^{
        beforeEach(^{
            [NymbolKit initializeSessionWithKey:@"abcd" secretKey:@"abcd"];
        });
        
        it(@"should store them in NSUserDefaults", ^{
            [[[[NSUserDefaults standardUserDefaults] valueForKey:@"nymbol_key"] should] equal:@"abcd"];
            [[[[NSUserDefaults standardUserDefaults] valueForKey:@"nymbol_secret"] should] equal:@"abcd"];
        });
        
        it(@"should be available using getter methods", ^{
            [[[NymbolKit currentKey] should] equal:@"abcd"];
            [[[NymbolKit currentSecret] should] equal:@"abcd"];
        });
        
        it(@"should provide an authorization header key", ^{
            [[[NymbolKit authHeaderKey] should] equal:@"91f317c9c7c8b107a486b2296c2f0e2c"];
        });
    });

});

SPEC_END