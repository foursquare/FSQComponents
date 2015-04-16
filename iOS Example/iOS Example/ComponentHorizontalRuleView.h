//
//  ComponentHorizontalRuleView.h
//  iOS Example
//
//  Created by Cameron Mulhern on 2/27/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSQComposable.h"

@interface ComponentHorizontalRuleViewModel : NSObject

@property (nonatomic, readonly) UIEdgeInsets insets;
@property (nonatomic, readonly) UIColor *color;

- (instancetype)init;
- (instancetype)initWithInsets:(UIEdgeInsets)insets;
- (instancetype)initWithInsets:(UIEdgeInsets)insets color:(UIColor *)color;

@end

@interface ComponentHorizontalRuleView : UIView <FSQComposable>

- (void)configureWithViewModel:(ComponentHorizontalRuleViewModel *)model;

+ (CGSize)sizeForViewModel:(ComponentHorizontalRuleViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(ComponentHorizontalRuleViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
