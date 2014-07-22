#import "Kiwi.h"
#import "Nocilla.h"
#import "NYMTaxonomy.h"

SPEC_BEGIN(NYMTaxonomySpecs)

beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterAll(^{
    [[LSNocilla sharedInstance] stop];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

describe(@"Fetching all taxonomies", ^{
    context(@"after successful fetching", ^{
        NSArray __block *parentTaxonomies;
        NYMCollection __block *collection;
        
        beforeEach(^{
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/1/taxonomies.json").
            andReturn(200).
            withHeaders(@{@"Content-Type": @"application/json"}).
            withBody(@"[{\"terms\": 6, \"name\": \"Pictures\", \"tags\": [\"tag-1\"]}]");
            collection = [NYMCollection new];
            [collection setPk:@"1"];
            [NYMTaxonomy allTaxonomiesForCollection:collection WithBlock:^(NSArray *taxonomies, NSError *error) {
                parentTaxonomies = taxonomies;
            }];
        });
        
        it(@"should have populated the block response with taxonomies.", ^{
            [[expectFutureValue(theValue(parentTaxonomies.count)) shouldEventually] equal:1 withDelta:0];
        });
        
        it(@"should populate the taxonomy with name.", ^{
            [[expectFutureValue([(NYMTaxonomy *)[parentTaxonomies objectAtIndex:0] name]) shouldEventually] equal:@"Pictures"];
        });
        
        it(@"should have access to the parent collection.", ^{
            [[expectFutureValue([(NYMTaxonomy *)[parentTaxonomies objectAtIndex:0] collection]) shouldEventually] equal:collection];
        });
        
        it(@"should populate any tags.", ^{
            [[expectFutureValue(theValue([[(NYMTaxonomy *)[parentTaxonomies objectAtIndex:0] tags] count])) shouldEventually] equal:1 withDelta:0];
        });

    });

});


SPEC_END


