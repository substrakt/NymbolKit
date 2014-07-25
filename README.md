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
        # Maybe reload a table view here, or something else...
    }
}];
```
