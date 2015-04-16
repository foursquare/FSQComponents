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

+ (CGSize)sizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
