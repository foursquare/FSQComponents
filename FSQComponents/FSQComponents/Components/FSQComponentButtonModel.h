//
//  FSQComponentButtonModel.h
//  iOS Example
//
//  Created by Cameron Mulhern on 4/14/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSQComposable.h"

@interface FSQComponentButtonModel : NSObject

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic) CGFloat heightConstraint;

@property (nonatomic) CGFloat horizontalPadding;
@property (nonatomic) CGFloat verticalPadding;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

- (UIImage *)imageForState:(UIControlState)state;
- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@interface UIButton (FSQComponentButton) <FSQComposable>

- (void)configureWithViewModel:(FSQComponentButtonModel *)model;

+ (CGSize)sizeForViewModel:(FSQComponentButtonModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(FSQComponentButtonModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end