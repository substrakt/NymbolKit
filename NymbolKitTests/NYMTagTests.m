#import "Kiwi.h"
#import "NYMTag.h"

SPEC_BEGIN(NYMTagSpecs)

describe(@"A tag", ^{
   
    NYMTag __block *tag;
    
    beforeEach(^{
        tag = [NYMTag new];
    });
    
    context(@"where no parameters have been set", ^{
       it(@"should have a nil name.", ^{
           [[[tag name] should] beNil];
       });
        
        it(@"should have a nil object.", ^{
            [[[tag object] should] beNil];
        });
    });
    
    context(@"that has a name", ^{
        beforeEach(^{
            tag.name = @"Jon Snow";
        });
        
        it(@"should be readable.", ^{
            [[tag.name should] equal:@"Jon Snow"];
        });
        
        it(@"should be writable.", ^{
            tag.name = @"Sansa Stark";
            [[tag.name should] equal:@"Sansa Stark"];
        });
    });
    
    context(@"that has an associated NYMObject", ^{
        beforeEach(^{
            NYMObject __block *object = [NYMObject new];
            object.name = @"Example object";
            tag.object = object;
        });
        
        it(@"should be readable.", ^{
            [[tag.object.name should] equal:@"Example object"];
        });
    });
    
});

SPEC_END