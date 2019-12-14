#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFFPriority) {
    FFFPriorityLow,
    FFFPriorityNormal,
    FFFPriorityHigh
};

/**
 * Object containing an image URL and associated metadata.
 */
@interface FFFastImageSource : NSObject

@property (nonatomic) NSURL* uri;
@property (nonatomic) NSString* defaultUrl;
@property (nonatomic) NSString* blurHash;
@property (nonatomic) FFFPriority priority;
@property (nonatomic) NSDictionary *headers;

- (instancetype)initWithURL:(NSURL *)url
                 defaultUrl:(NSString *)defaultUrl
                   blurHash:(NSString *)blurHash
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers;

@end
