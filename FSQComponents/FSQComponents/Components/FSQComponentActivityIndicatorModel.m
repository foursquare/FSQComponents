//
//  FSQComponentActivityIndicatorModel.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 8/24/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "FSQComponentActivityIndicatorModel.h"
#import <objc/runtime.h>

#pragma mark - FSQComponentActivityIndicatorModel -

@implementation FSQComponentActivityIndicatorModel

- (instancetype)initWithStyle:(UIActivityIndicatorViewStyle)style {
    if ((self = [super init])) {
        _style = style;
    }
    return self;
}

@end

#pragma mark - UIActivityIndicatorView (FSQComponentActivityIndicator) -

@interface UIActivityIndicatorView (FSQComponentActivityIndicatorPrivate)

@property (nonatomic) FSQComponentActivityIndicatorModel *fsqComponentActivityIndicatorModel;

@end

@implementation UIActivityIndicatorView (FSQComponentActivityIndicator)

- (void)configureWithViewModel:(FSQComponentActivityIndicatorModel *)model {
    self.fsqComponentActivityIndicatorModel = model;
    self.activityIndicatorViewStyle = model.style;
    [self startAnimating];
}

- (void)prepareForReuse {
    self.fsqComponentActivityIndicatorModel = nil;
    [self stopAnimating];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

#pragma mark - Private

- (void)setFsqComponentActivityIndicatorModel:(FSQComponentActivityIndicatorModel *)fsqComponentActivityIndicatorModel {
    return objc_setAssociatedObject(self, @selector(fsqComponentActivityIndicatorModel), fsqComponentActivityIndicatorModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FSQComponentActivityIndicatorModel *)fsqComponentActivityIndicatorModel {
    return objc_getAssociatedObject(self, @selector(fsqComponentActivityIndicatorModel));
}

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(FSQComponentActivityIndicatorModel *)model constrainedToSize:(CGSize)constrainedToSize {
    static dispatch_once_t predicate;
    static UIActivityIndicatorView *indicatorForSizing;
    dispatch_once(&predicate, ^() {
        indicatorForSizing = [[self alloc] initWithFrame:CGRectZero];
    });
    
    [indicatorForSizing configureWithViewModel:model];
    
    CGSize size = [indicatorForSizing sizeThatFits:constrainedToSize];
    return CGSizeMake(MIN(size.width, constrainedToSize.width), MIN(size.height, constrainedToSize.height));
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentActivityIndicatorModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
