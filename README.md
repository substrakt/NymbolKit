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

```
[NymbolKit initializeSessionWithKey:@"abcd" secretKey:@"abcd"];
```

## Collections

Fetch all collections:

```
[NYMCollection allCollectionsWithBlock:^(NSArray *collections, NSError *error) {
    if(!error) {
        // collections will be an array of NYMCollection objects
    }
}];