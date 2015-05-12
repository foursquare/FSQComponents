//
//  FSQComponentSizing.h
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 5/12/15.
//
//

#import <Foundation/Foundation.h>

extern CGFloat fsq_componentScreenScale();

static inline CGFloat fsq_componentPixelFloor(CGFloat value) {
    CGFloat scale = fsq_componentScreenScale();
    return floor(value * scale) / scale;
}

static inline CGFloat fsq_componentPixelRound(CGFloat value) {
    CGFloat scale = fsq_componentScreenScale();
    return round(value * scale) / scale;
}

static inline CGFloat fsq_componentPixelCeil(CGFloat value) {
    CGFloat scale = fsq_componentScreenScale();
    return ceil(value * scale) / scale;
}
