//
//  ComponentHorizontalRuleView.m
//  iOS Example
//
//  Created by Cameron Mulhern on 2/27/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ComponentHorizontalRuleView.h"

#pragma mark - ComponentHorizontalRuleViewModel -

@implementation ComponentHorizontalRuleViewModel

- (instancetype)init {
    return [self initWithInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    return [self initWithInsets:insets color:[UIColor colorWithWhite:0.8 alpha:1.0]];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets color:(UIColor *)color {
    if ((self = [super init])) {
        _insets = insets;
        _color = color;
    }
    return self;
}

@end

#pragma mark - ComponentHorizontalRuleView -

@interface ComponentHorizontalRuleView ()

@property (nonatomic) ComponentHorizontalRuleViewModel *model;
@property (nonatomic) UIView *lineView;

@end

@implementation ComponentHorizontalRuleView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets insets = self.model.insets;
    CGFloat lineWidth = self.frame.size.width - insets.left - insets.right;
    self.lineView.frame = CGRectMake(insets.left, insets.top, lineWidth, [[self class] lineHeight]);
}

- (void)configureWithViewModel:(ComponentHorizontalRuleViewModel *)model {
    self.model = model;
    self.lineView.backgroundColor = model.color;
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    self.model = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

#pragma mark - Class methods

+ (CGFloat)lineHeight {
    return 1.0 / [[UIScreen mainScreen] scale];
}

+ (CGFloat)heightForViewModel:(ComponentHorizontalRuleViewModel *)model width:(CGFloat)width {
    CGFloat height = 0.0;
    height += model.insets.top;
    height += [self lineHeight];
    height += model.insets.bottom;
    return height;
}

+ (CGFloat)estimatedHeightForViewModel:(ComponentHorizontalRuleViewModel *)model width:(CGFloat)width {
    return [self heightForViewModel:model width:width];
}

@end
