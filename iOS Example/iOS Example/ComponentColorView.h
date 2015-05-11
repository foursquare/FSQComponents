//
//  ComponentColorView.h
//  iOS Example
//
//  Created by Cameron Mulhern on 5/11/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSQComposable.h"

@interface ComponentColorViewModel : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat desiredHeight;

- (instancetype)initWithColor:(UIColor *)color;

@end

@interface ComponentColorView : UIView <FSQComposable>

- (void)configureWithViewModel:(ComponentColorViewModel *)model;

+ (CGSize)sizeForViewModel:(ComponentColorViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(ComponentColorViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
