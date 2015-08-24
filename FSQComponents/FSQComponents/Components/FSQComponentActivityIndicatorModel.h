//
//  FSQComponentActivityIndicatorModel.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 8/24/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSQComposable.h"

@interface FSQComponentActivityIndicatorModel : NSObject

@property (nonatomic, readonly) UIActivityIndicatorViewStyle style;

- (instancetype)initWithStyle:(UIActivityIndicatorViewStyle)style;

@end

@interface UIActivityIndicatorView (FSQComponentActivityIndicator) <FSQComposable>

- (void)configureWithViewModel:(FSQComponentActivityIndicatorModel *)model;

+ (CGSize)sizeForViewModel:(FSQComponentActivityIndicatorModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(FSQComponentActivityIndicatorModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end