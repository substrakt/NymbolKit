#import "Kiwi.h"
#import "NYMLink.h"

SPEC_BEGIN(NYMLinkSpecs)

describe(@"A link", ^{
    
    NYMLink __block *link;
    
    beforeEach(^{
        link = [NYMLink new];
    });
    
    context(@"where no parameters have been set", ^{
        it(@"should have a nil title.", ^{
            [[[link title] should] beNil];
        });
        
        it(@"should have a nil object.", ^{
            [[[link object] should] beNil];
        });
    });
    
    context(@"that has a name", ^{
        beforeEach(^{
            link.title = @"Interesting Website";
        });
        
        it(@"should be readable.", ^{
            [[link.title should] equal:@"Interesting Website"];
        });
        
        it(@"should be writable.", ^{
            link.title = @"Sansa Stark";
            [[link.title should] equal:@"Sansa Stark"];
        });
    });
    
    context(@"that has an associated NYMObject", ^{
        beforeEach(^{
            NYMObject __block *object = [NYMObject new];
            object.name = @"Example object";
            link.object = object;
        });
        
        it(@"should be readable.", ^{
            [[link.object.name should] equal:@"Example object"];
        });
    });
    
});

SPEC_END