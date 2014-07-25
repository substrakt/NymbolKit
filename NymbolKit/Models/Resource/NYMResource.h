#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResourceTypes) {
    NYMResourceTypeText,
    NYMResourceTypeLink,
    NYMResourceTypeImage,
    NYMResourceTypeAudio,
    NYMResourceTypeVideo
};

@interface NYMResource : NSObject
@property (nonatomic) ResourceTypes kind;
@property (nonatomic) NSURL *url;
@end
