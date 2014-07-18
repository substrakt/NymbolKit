#import "Kiwi.h"
#import "NYMObject.h"

SPEC_BEGIN(NYMObjectSpec)

describe(@"An object", ^{
    
    
    
    context(@"which has been newly created", ^{
        NYMObject __block *object;
        beforeEach(^{
            object = [NYMObject new];
        });
        
        it(@"should have nil for the name", ^{
            [[object name] shouldBeNil];
        });
    });
    
});

SPEC_END