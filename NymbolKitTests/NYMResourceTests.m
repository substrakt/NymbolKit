#import "Kiwi.h"
#import "NYMResource.h"

SPEC_BEGIN(NYMResourceSpec)

describe(@"A resource", ^{
    NYMResource __block *resource;

    context(@"with type NYMResourceTypeText", ^{
        resource = [[NYMResource alloc] init];
        resource.kind = NYMResourceTypeText;
    });

});

SPEC_END