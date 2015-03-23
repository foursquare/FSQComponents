//
//  FSQComponentLayoutManager.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSQComponentsViewModel;

typedef struct {
    CGRect frame;
    UIEdgeInsets insets;
} FSQComponentLayoutInfo;

static inline FSQComponentLayoutInfo FSQComponentLayoutInfoMake(CGRect frame, UIEdgeInsets insets) {
    FSQComponentLayoutInfo info;
    info.frame = frame;
    info.insets = insets;
    return info;
}

NS_ROOT_CLASS
@interface FSQComponentLayoutManager

+ (NSArray *)componentLayoutInfoForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width;
+ (CGFloat)heightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width;
+ (CGFloat)estimatedHeightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width;

@end
