//
//  ComponentTextView.h
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSQComposable.h"

@interface ComponentTextViewModel : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) UIColor *color;

@property (nonatomic, readonly) BOOL multiline;

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color multiline:(BOOL)multiline;

@end

@interface ComponentTextView : UIView <FSQComposable>

- (void)configureWithViewModel:(ComponentTextViewModel *)model;

+ (CGSize)sizeForViewModel:(ComponentTextViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(ComponentTextViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
