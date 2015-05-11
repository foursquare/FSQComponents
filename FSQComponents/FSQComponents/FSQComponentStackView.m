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

@property (nonatomic) UIView<FSQComposable> *bottomView;
@property (nonatomic) UIView<FSQComposable> *topView;

@end

@implementation FSQComponentStackView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor redColor];
    self.bottomView.frame = self.bounds;
    self.topView.frame = self.bounds;
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
    
    return view;
}

- (void)configureWithViewModel:(FSQComponentStackViewModel *)model {
    self.bottomView = [self checkViewCompatibility:self.bottomView withSpecification:model.bottomSpecification atIndex:0];
    self.topView = [self checkViewCompatibility:self.topView withSpecification:model.topSpecification atIndex:1];
    
    [self.bottomView configureWithViewModel:model.bottomSpecification.viewModel];
    [self.topView configureWithViewModel:model.topSpecification.viewModel];
}

- (void)prepareForReuse {
    [self.bottomView prepareForReuse];
    [self.topView prepareForReuse];
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
    return [specification.viewClass sizeForViewModel:specification.viewModel constrainedToSize:constrainedToSize];
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentStackViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    FSQComponentSpecification *specification = (model.stackType == FSQComponentStackTypeStretchBottom) ? model.topSpecification : model.bottomSpecification;
    return [specification.viewClass estimatedSizeForViewModel:specification.viewModel constrainedToSize:constrainedToSize];
}

@end
