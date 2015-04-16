//
//  ComponentTextView.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ComponentTextView.h"

#pragma mark - ComponentTextViewModel -

@implementation ComponentTextViewModel

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    return [self initWithText:text font:font color:color multiline:NO];
}

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color multiline:(BOOL)multiline {
    if ((self = [super init])) {
        _text = text;
        _font = font;
        _color = color;
        _multiline = multiline;
    }
    return self;
}

@end

#pragma mark - ComponentTextView -

@interface ComponentTextView ()

@property (nonatomic) UILabel *label;

@end

@implementation ComponentTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)configureWithViewModel:(ComponentTextViewModel *)model {
    self.label.text = model.text;
    self.label.font = model.font;
    self.label.textColor = model.color;
    self.label.numberOfLines = (model.multiline) ? 0 : 1;
}

- (void)prepareForReuse {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

#pragma mark - Class methods

+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font width:(CGFloat)width {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return ceilf(rect.size.height);
}

+ (CGSize)sizeForViewModel:(ComponentTextViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    CGFloat height = (model.multiline) ? [self heightForString:model.text font:model.font width:constrainedToSize.width] : ceil(model.font.lineHeight);
    return CGSizeMake(constrainedToSize.width, height);
}

+ (CGSize)estimatedSizeForViewModel:(ComponentTextViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
