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
            [NymbolKit initializeSessionWithKey:@"abcd" secretKey:@"abcd" appIdentifier:@"com.example.example"];
        });
        
        it(@"should be available using getter methods", ^{
            [[[NymbolKit currentKeyForAppIdentifier:@"com.example.example"] should] equal:@"abcd"];
            [[[NymbolKit currentSecretForAppIdentifier:@"com.example.example"] should] equal:@"abcd"];
        });
        
        it(@"should provide an authorization header key", ^{
            [[[NymbolKit authHeaderKeyForAppIdentifier:@"com.example.example"] should] equal:@"91f317c9c7c8b107a486b2296c2f0e2c"];
        });
    });

});

SPEC_END