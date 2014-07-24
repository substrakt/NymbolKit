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
        
        context(@"and then fetching all of the terms objects", ^{
            NSArray __block *parentObjects;
           beforeEach(^{
               stubRequest(@"GET", @"http://nymbol.co.uk/api/manager/collection/4/assets.json?taxonomy%5B3%5D=355").
               andReturn(200).
               withHeaders(@{@"Content-Type": @"application/json"}).
               withBody(@"[{\"rating\": null, \"uid\": \"2SgUFHe\", \"links\": [], \"comments\": 0, \"id\": 6102, \"tags\": [], \"share_url\": \"https://nymbol.co.uk/share/a/HpqHAdhSXvC7GnUdwY-hQPE-2SgUFHe/\", \"location\": \"52.032218104145294, -3.9990234375\", \"latitude\": \"52.032218104145294\", \"taxonomies\": [{\"terms\": [{\"assets\": 2, \"id\": 360, \"name\": \"Blue things\"}], \"id\": 32, \"name\": \"First Taxonomy\"}], \"status\": 1, \"description\": \"\", \"ordering_name\": \"cup of tea\", \"collection\": 45, \"unpublish_from\": null, \"resource_types\": [], \"publish_from\": null, \"noun\": \"object\", \"name\": \"Cup of tea\", \"fields\": {}, \"curator\": 85, \"longitude\": \"-3.9990234375\", \"featured_resource\": null}, {\"rating\": null, \"uid\": \"9xc0LfF\", \"links\": [], \"comments\": 0, \"id\": 6101, \"tags\": [], \"share_url\": \"https://nymbol.co.uk/share/a/HpqHAdhSXvC7GnUdwY-hQPE-9xc0LfF/\", \"location\": \"Cardiff\", \"latitude\": \"51.4835299\", \"taxonomies\": [{\"terms\": [{\"assets\": 2, \"id\": 360, \"name\": \"Blue things\"}], \"id\": 32, \"name\": \"First Taxonomy\"}], \"status\": 1, \"description\": \"\", \"ordering_name\": \"toy lego car\", \"collection\": 45, \"unpublish_from\": null, \"resource_types\": [{\"count\": 1, \"kind\": \"image\", \"label_plural\": \"Images\", \"label\": \"Image\"}], \"publish_from\": null, \"noun\": \"object\", \"name\": \"Toy Lego Car\", \"fields\": {}, \"curator\": 85, \"longitude\": \"-3.1836873\", \"featured_resource\": 10046}]");
               NYMTaxonomyTerm *term = [parentTerms objectAtIndex:0];
               [term allObjectsWithBlock:^(NSArray *objects, NSError *error) {
                   parentObjects = objects;
               }];
           });
            
            it(@"should create two objects.", ^{
                [[expectFutureValue(theValue(parentObjects.count)) shouldEventually] equal:2 withDelta:0];
            });
            
            it(@"should assign the name and pk.", ^{
                [[expectFutureValue([(NYMObject *)[parentObjects objectAtIndex:0] name]) shouldEventually] equal:@"Cup of tea"];
                [[expectFutureValue([(NYMObject *)[parentObjects objectAtIndex:0] pk]) shouldEventually] equal:@"6102"];
            });
        });
    });
    
    context(@"with an unsuccessful response", ^{
        
    });
});

SPEC_END