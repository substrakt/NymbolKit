# NymbolKit

Objective-C wrapper around the Nymbol API.

## Installation

Just use CocoaPods:

```
# Podfile
pod 'NymbolKit'
```

`$ pod install`

## Usage

**Before doing anything** you must set your API key.

```objectivec
[NymbolKit initializeSessionWithKey:@"abcd" secretKey:@"abcd"];
```

## Collections

Fetch all collections:

```objectivec
[NYMCollection allCollectionsWithBlock:^(NSArray *collections, NSError *error) {
    if(!error) {
        // collections will be an array of NYMCollection objects
    }
}];
```

Fetch a single collection:

```objectivec
NYMCollection __block *parentCollection;
[NYMCollection collectionWithUID:4 block:^(NYMCollection *collection, NSError *error) {
    if(!error) {
        parentCollection = collection;
        // Maybe reload a table view here, or something else...
    }
}];
```

## Objects

Fetch all objects belonging to a collection. Note that you don't need to fetch the collection first, just create one with the correct pk. (`pk` stands for primary key and maps to the object `id`. `id` is a protected word in Objective-C so we can't use it here.)

```objectivec
NYMCollection *collection = [NYMCollection new];
collection.pk = @"4";
[NYMObject allObjectsForCollection:collection WithBlock:^(NSArray *objects, NSError *error){
    // objects are available here
}];
```
> Note: This call doesn't populate the data for the objects. It only populates `name`, `pk` and `collection`. You'll need to run `fetchResourcesWithBlock:` to get other information about the object.

Fetch all data for an object:

```objectivec
NYMCollection *collection = [NYMCollection new];
collection.pk = @"4";
[NYMObject allObjectsForCollection:collection WithBlock:^(NSArray *objects, NSError *error){
    NYMObject *firstObject = [objects objectAtIndex:0];
    firstObject fetchResourcesWithBlock....
}];
```

`NYMObjects` conform to the `MKAnnotation` protocol meaning you can add them to a `MKMapView` very easily. 
