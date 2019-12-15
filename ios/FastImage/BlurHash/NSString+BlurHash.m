//
//  NSString+BlurHash.m
//  Copyright © 2019 Tomi Kankaanpää. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+BlurHash.h"

const NSString* ENCODE_CHARACTERS = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~";

@implementation NSString (BlurHash)

- (NSUInteger)decode83 {
    NSUInteger value = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        NSString * const str = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        const unichar digit = [ENCODE_CHARACTERS rangeOfString:str].location;
        value = value * 83 + digit;
    }
    return value;
}

@end
