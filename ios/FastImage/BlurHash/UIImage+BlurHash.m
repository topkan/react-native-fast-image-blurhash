//
//  UIImage+BlurHash.m
//  Copyright © 2019 Tomi Kankaanpää. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIImage+BlurHash.h"
#import "NSString+BlurHash.h"

#define guard(CONDITION) if (CONDITION) {}

#define SIGN(n) ((n) < 0 ? -1 : 1)
#define SIGN_POW(val, exp) (SIGN(val) * pow(labs(val), exp))

static CGFloat sRGBToLinear(CGFloat value) {
    const CGFloat v = value / 255;
    if (v <= 0.04045) {
        return v / 12.92;
    } else {
        return pow((v + 0.055) / 1.055, 2.4);
    }
}

static NSInteger linearTosRGB(CGFloat value) {
    const NSInteger v = MAX(0.0, MIN(1, value));
    if (v <= 0.0031308) {
        return v * 12.92 * 255 + 0.5;
    } else {
        return (1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5;
    }
}

static UIColor * decodeDC(NSInteger value) {
    return [UIColor colorWithRed:sRGBToLinear(value >> 16)
                           green:sRGBToLinear((value >> 8) & 255)
                            blue:sRGBToLinear(value & 255)
                           alpha:1.0];
}

static UIColor * decodeAC(NSInteger value, CGFloat maximumValue) {
    const NSInteger quantR = value / (19 * 19);
    const NSInteger quantG = (value / 19) % 19;
    const NSInteger quantB = value % 19;
    
    return [UIColor colorWithRed:SIGN_POW((quantR - 9) / 9, 2.0)
                           green:SIGN_POW((quantG - 9) / 9, 2.0)
                            blue:SIGN_POW((quantB - 9) / 9, 2.0)
                           alpha:1.0];
}

@implementation UIImage (BlurHash)

- (UIImage*)initWithBlurHash:(NSString*)blurHash size:(CGSize)size punch:(CGFloat)punch {
    guard (blurHash.length < 6) else { return nil; }
    
    const NSInteger sizeFlag = [[blurHash substringWithRange: NSMakeRange(0, 1)] decode83];
    const NSInteger numY = (sizeFlag / 9) + 1;
    const NSInteger numX = (sizeFlag % 9) + 1;

    const NSInteger quantisedMaximumValue = [[blurHash substringWithRange: NSMakeRange(1, 1)] decode83];
    const CGFloat maximumValue = ((CGFloat)quantisedMaximumValue + 1) / 166;

    guard (blurHash.length == 4 + 2 * numX * numY) else { return nil; }
    
    NSMutableArray * const colors = [NSMutableArray arrayWithCapacity: numX * numY];
    
    for (NSUInteger i = 0; i < colors.count; i++) {
        if (i == 0) {
            const NSUInteger value = [[blurHash substringWithRange: NSMakeRange(2, 6)] decode83];
            colors[i] = decodeDC(value);
        } else {
            const NSUInteger value = [[blurHash substringWithRange: NSMakeRange(4 + i * 2, 6 + i * 2)] decode83];
            colors[i] = decodeAC(value, maximumValue * punch);
        }
    }
    
    const NSInteger width = size.width;
    const NSInteger height = size.height;
    
    const NSInteger bytesPerRow = width * 3;
    
    const CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height);
    guard (data) else { return nil; }
    CFDataSetLength(data, bytesPerRow * height);
    UInt8 * pixels = CFDataGetMutableBytePtr(data);
    guard (pixels) else { return nil; }

    for (NSInteger y = 0; y < height; y++) {
        for (NSInteger x = 0; x < width; x++) {
            CGFloat r = 0.0, g = 0.0, b = 0.0;
            
            for (NSInteger j = 0; j < numY; j++) {
                for (NSInteger i = 0; i < numX; i++) {
                    CGFloat red, green, blue, alpha;
                    CGFloat basis = cos(M_PI * (CGFloat)x * (CGFloat)i / (CGFloat)width)
                                  * cos(M_PI * (CGFloat)y * (CGFloat)j / (CGFloat)height);
                    const UIColor * color = [colors objectAtIndex: i + j * numX];
                    guard (color) else { return nil; }
                    [color getRed:&red green:&green blue:&blue alpha:&alpha];
                    r += red * basis;
                    g += green * basis;
                    b += blue * basis;
                }
            }
            const UInt8 intR = linearTosRGB(r);
            const UInt8 intG = linearTosRGB(g);
            const UInt8 intB = linearTosRGB(b);

            pixels[3 * x + 0 + y * bytesPerRow] = intR;
            pixels[3 * x + 1 + y * bytesPerRow] = intG;
            pixels[3 * x + 2 + y * bytesPerRow] = intB;
        }
    }
    const CGBitmapInfo bitmapInfo = kCGBitmapAlphaInfoMask & kCGImageAlphaNone;
    const CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    guard (provider) else { return nil; }
    const CGImageRef image = CGImageCreate(width, height, 8, 24, bytesPerRow, CGColorSpaceCreateDeviceRGB(), bitmapInfo, provider, nil, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    guard (image) else { return nil; }

    return [self initWithCGImage:image];
}

@end
