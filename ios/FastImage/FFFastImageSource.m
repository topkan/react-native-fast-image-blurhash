#import "FFFastImageSource.h"

@implementation FFFastImageSource

- (instancetype)initWithURL:(NSURL *)url defaultUrl:(NSString *)defaultUrl
                   blurHash:(NSString *)blurHash
                   priority:(FFFPriority)priority
                    headers:(NSDictionary *)headers
{
    self = [super init];
    if (self) {
        _uri = url;
        _defaultUrl= defaultUrl;
        _priority = priority;
        _blurHash = blurHash;
        _headers = headers;
    }
    return self;
}

@end
