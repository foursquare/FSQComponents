//
//  FSQComponentStackView.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 5/12/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
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
