//
//  FSQComponentSizing.m
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 5/12/15.
//
//

#import "FSQComponentSizing.h"

CGFloat fsq_componentScreenScale() {
    static dispatch_once_t predicate;
    static CGFloat scale;
    dispatch_once(&predicate, ^() {
        scale = [[UIScreen mainScreen] scale];
    });
    return scale;
}
