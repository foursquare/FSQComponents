//
//  FSQComponentLabelModel.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 5/8/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSQComposable.h"

@interface FSQComponentLabelModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) NSLineBreakMode lineBreakMode;

// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
@property (nonatomic) NSAttributedString *attributedText;

@property (nonatomic) NSInteger numberOfLines;

@property (nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (nonatomic) UIBaselineAdjustment baselineAdjustment;
@property (nonatomic) CGFloat minimumScaleFactor;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;
- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText;

@end

@interface UILabel (FSQComponentLabel) <FSQComposable>

- (void)configureWithViewModel:(FSQComponentLabelModel *)model;

+ (CGSize)sizeForViewModel:(FSQComponentLabelModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(FSQComponentLabelModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
