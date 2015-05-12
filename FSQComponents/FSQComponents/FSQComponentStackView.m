//
//  FSQComponentStackView.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 5/11/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "FSQComponentStackView.h"

#import "FSQComponentReuseManager.h"
#import "FSQComponentSpecification.h"
#import "FSQComponentsView.h"

#pragma mark - FSQComponentStackViewModel -

@implementation FSQComponentStackViewModel

- (instancetype)initWithBottomSpecification:(FSQComponentSpecification *)bottomSpecification topSpecification:(FSQComponentSpecification *)topSpecification stackType:(FSQComponentStackType)stackType {
    if ((self = [super init])) {
        _bottomSpecification = bottomSpecification;
        _topSpecification = topSpecification;
        _stackType = stackType;
    }
    return self;
}

@end

#pragma mark - FSQComponentStackView -

@interface FSQComponentStackView ()

@property (nonatomic) FSQComponentStackViewModel *model;

@property (nonatomic) UIView<FSQComposable> *bottomView;
@property (nonatomic) UIView<FSQComposable> *topView;

@end

@implementation FSQComponentStackView

+ (UIEdgeInsets)smartEdgeInsetsAdjustedForInsets:(UIEdgeInsets)insets {
    if (insets.top == kFSQComponentSmartInsets.top) {
        insets.top = 0.0;
    }
    if (insets.left == kFSQComponentSmartInsets.left) {
        insets.left = 0.0;
    }
    if (insets.bottom == kFSQComponentSmartInsets.bottom) {
        insets.bottom = 0.0;
    }
    if (insets.right == kFSQComponentSmartInsets.right) {
        insets.right = 0.0;
    }
    return insets;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bottomView.frame = UIEdgeInsetsInsetRect(self.bounds, [[self class] smartEdgeInsetsAdjustedForInsets:self.model.bottomSpecification.insets]);
    self.topView.frame = UIEdgeInsetsInsetRect(self.bounds, [[self class] smartEdgeInsetsAdjustedForInsets:self.model.topSpecification.insets]);
}

- (UIView<FSQComposable> *)checkViewCompatibility:(UIView<FSQComposable> *)view withSpecification:(FSQComponentSpecification *)specification atIndex:(NSInteger)index {
    Class viewClass = [specification viewClass];
    if (![view isKindOfClass:viewClass]) {
        if (view) {
            [view removeFromSuperview];
            [[FSQComponentReuseManager shared] addViewToReusePool:view];
        }
        
        view = [[FSQComponentReuseManager shared] dequeueViewForClass:viewClass];
        [self insertSubview:view atIndex:index];
    }
    else {
        [view prepareForReuse];
    }
    
    return view;
}

- (void)configureWithViewModel:(FSQComponentStackViewModel *)model {
    self.model = model;
    
    self.bottomView = [self checkViewCompatibility:self.bottomView withSpecification:model.bottomSpecification atIndex:0];
    self.topView = [self checkViewCompatibility:self.topView withSpecification:model.topSpecification atIndex:1];
    
    [self.bottomView configureWithViewModel:model.bottomSpecification.viewModel];
    [self.topView configureWithViewModel:model.topSpecification.viewModel];
}

- (void)prepareForReuse {
    self.model = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self.bottomView setHighlighted:highlighted animated:animated];
    [self.topView setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self.bottomView setHighlighted:selected animated:animated];
    [self.topView setSelected:selected animated:animated];
}

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(FSQComponentStackViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    FSQComponentSpecification *specification = (model.stackType == FSQComponentStackTypeStretchBottom) ? model.topSpecification : model.bottomSpecification;
    
    // Call sizeForViewModel:constrainedToSize: on stretch specification for backwards compatibility.
    FSQComponentSpecification *otherSpecification = (model.stackType == FSQComponentStackTypeStretchBottom) ? model.bottomSpecification : model.topSpecification;
    [otherSpecification.viewClass sizeForViewModel:otherSpecification.viewModel constrainedToSize:constrainedToSize];
    
    CGSize size = [specification.viewClass sizeForViewModel:specification.viewModel constrainedToSize:constrainedToSize];
    if (model.minimumHeight != 0.0) {
        size.height = MAX(size.height, model.minimumHeight);
    }
    
    return size;
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentStackViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    FSQComponentSpecification *specification = (model.stackType == FSQComponentStackTypeStretchBottom) ? model.topSpecification : model.bottomSpecification;
    
    // Call sizeForViewModel:constrainedToSize: on stretch specification for backwards compatibility.
    FSQComponentSpecification *otherSpecification = (model.stackType == FSQComponentStackTypeStretchBottom) ? model.bottomSpecification : model.topSpecification;
    [otherSpecification.viewClass sizeForViewModel:otherSpecification.viewModel constrainedToSize:constrainedToSize];
    
    CGSize size = [specification.viewClass estimatedSizeForViewModel:specification.viewModel constrainedToSize:constrainedToSize];
    if (model.minimumHeight != 0.0) {
        size.height = MAX(size.height, model.minimumHeight);
    }
    return size;
}

@end
