//
//  FSQComponentLabelModel.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 5/8/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "FSQComponentLabelModel.h"
#import <objc/runtime.h>

#pragma mark - FSQComponentLabelModel -

@implementation FSQComponentLabelModel

- (instancetype)init {
    if ((self = [super init])) {
        self.textAlignment = NSTextAlignmentLeft;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        self.numberOfLines = 1;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text font:[UIFont systemFontOfSize:[UIFont systemFontSize]] textColor:[UIColor whiteColor]];
}

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    if ((self = [self init])) {
        self.text = text;
        self.font = font;
        self.textColor = textColor;
    }
    return self;
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText {
    if ((self = [self init])) {
        self.attributedText = attributedText;
    }
    return self;
}

@end

#pragma mark - UILabel (FSQComponentLabel) -

@interface UILabel (FSQComponentLabelPrivate)

@property (nonatomic) FSQComponentLabelModel *fsqComponentLabelModel;

@end

@implementation UILabel (FSQComponentLabel)

- (void)configureWithViewModel:(FSQComponentLabelModel *)model {
    self.fsqComponentLabelModel = model;
    
    self.backgroundColor = model.backgroundColor;
    self.opaque = (self.backgroundColor != nil);
    
    if (model.attributedText) {
        self.attributedText = model.attributedText;
    }
    else {
        self.text = model.text;
        self.font = model.font;
        self.textColor = model.textColor;
        self.textAlignment = model.textAlignment;
        self.lineBreakMode = model.lineBreakMode;
    }
    
    self.numberOfLines = model.numberOfLines;
    self.adjustsFontSizeToFitWidth = model.adjustsFontSizeToFitWidth;
    self.baselineAdjustment = model.baselineAdjustment;
    self.minimumScaleFactor = model.minimumScaleFactor;
}

- (void)prepareForReuse {
    self.fsqComponentLabelModel = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = self.fsqComponentLabelModel.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.backgroundColor = self.fsqComponentLabelModel.backgroundColor;
}

#pragma mark - Private

- (void)setFsqComponentLabelModel:(FSQComponentLabelModel *)fsqComponentLabelModel {
    return objc_setAssociatedObject(self, @selector(fsqComponentLabelModel), fsqComponentLabelModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FSQComponentLabelModel *)fsqComponentLabelModel {
    return objc_getAssociatedObject(self, @selector(fsqComponentLabelModel));
}

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(FSQComponentLabelModel *)model constrainedToSize:(CGSize)constrainedToSize {
    static dispatch_once_t predicate;
    static UILabel *labelForSizing;
    dispatch_once(&predicate, ^() {
        labelForSizing = [[self alloc] initWithFrame:CGRectZero];
    });
    
    [labelForSizing configureWithViewModel:model];
    
    CGSize size = [labelForSizing sizeThatFits:constrainedToSize];
    size.width += 2.0 * model.horizontalPadding;
    size.height += 2.0 * model.verticalPadding;
    return CGSizeMake(MIN(size.width, constrainedToSize.width), MIN(size.height, constrainedToSize.height));
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentLabelModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
