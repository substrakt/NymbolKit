#import "Kiwi.h"
#import "Nocilla.h"
#import "NYMTaxonomyTerm.h"
#import "NYMTaxonomy.h"

SPEC_BEGIN(NYMTaxonomyTermSpec)
beforeAll(^{
    [[LSNocilla sharedInstance] start];
});
afterAll(^{
    [[LSNocilla sharedInstance] stop];
});
afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

describe(@"Fetching all terms", ^{
    context(@"with a successful response of one taxonomy", ^{
        NSArray __block *parentTerms;
        NYMTaxonomy __block *taxonomy;
        beforeEach(^{
            NYMCollection *collection = [NYMCollection new];
            collection.pk = @"4";
            taxonomy = [NYMTaxonomy new];
            taxonomy.collection = collection;
            taxonomy.pk = @"3";
            
            stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/4/taxonomies/3/terms.json").
            andReturn(200).
            withHeaders(@{@"Content-Type": @"application/json"}).
            withBody(@"[{\"status\": 1,\"name\": \"a\",\"parent\": null,\"ordering_name\": \"a\",\"taxonomy\": 31,\"description\": \"\",\"tags\": [],\"share_url\": \"http://nymbol.co.uk/share/t/NsgWPgQ5RXVh67NjX2-8E90-nSQOPkW/SV9MtiE/\",\"collection\": 43,\"children\": [],\"longitude\": null,\"address\": null,\"latitude\": null,\"fields\": {},\"assets\": 1,\"id\": 355,\"uid\": \"SV9MtiE\"}]");
            
            
            [NYMTaxonomyTerm allTermsForTaxonomy:taxonomy WithBlock:^(NSArray *terms, NSError *error) {
                parentTerms = terms;
            }];
        });
        
        it(@"should create 1 taxonomy term object.", ^{
            [[expectFutureValue(theValue(parentTerms.count)) shouldEventually] equal:1 withDelta:0];
        });
        
        it(@"should set the taxonomy term name.", ^{
            [[expectFutureValue([(NYMTaxonomyTerm *)[parentTerms objectAtIndex:0] name]) shouldEventually] equal:@"a"];
        });
        
        it(@"should set the sharing url.", ^{
            [[expectFutureValue([(NYMTaxonomyTerm *)[parentTerms objectAtIndex:0] shareURL]) shouldEventually] equal:[NSURL URLWithString:@"http://nymbol.co.uk/share/t/NsgWPgQ5RXVh67NjX2-8E90-nSQOPkW/SV9MtiE/"]];
        });
        
        it(@"should set the taxonomy.", ^{
            [[expectFutureValue([(NYMTaxonomyTerm *)[parentTerms objectAtIndex:0] taxonomy]) shouldEventually] equal:taxonomy];
        });
    });
    
    context(@"with an unsuccessful response", ^{
        
    });
});

SPEC_END