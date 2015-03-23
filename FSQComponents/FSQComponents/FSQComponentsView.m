//
//  FSQComponentsView.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 1/14/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentsView.h"

#import "FSQComponentLayoutManager.h"
#import "FSQComponentReuseManager.h"

const UIEdgeInsets kFSQComponentSmartInsets = {CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX};

static NSString * const kReuseIdentifierDelimiter = @"|";

#pragma mark - FSQComponentsViewModel -

@implementation FSQComponentsViewModel

- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications {
    return [self initWithComponentSpecifications:componentSpecifications smartInsetsAppliesToEdges:YES];
}

- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications smartInsetsAppliesToEdges:(BOOL)smartInsetsAppliesToEdges {
    if ((self = [super init])) {
        _componentSpecifications = [componentSpecifications copy];
        _smartInsetsAppliesToEdges = YES;
        
        NSMutableArray *reuseComponents = [[NSMutableArray alloc] init];
        for (FSQComponentSpecification *specification in componentSpecifications) {
            [reuseComponents addObject:NSStringFromClass(specification.viewClass)];
        }
        _reuseIdentifier = [reuseComponents componentsJoinedByString:kReuseIdentifierDelimiter];
    }
    return self;
}

@end

#pragma mark - FSQComponentsView -

@interface FSQComponentsView ()

@property (nonatomic, copy) NSArray *views;
@property (nonatomic) FSQComponentsViewModel *model;

@end

@implementation FSQComponentsView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *layoutInfo = [FSQComponentLayoutManager componentLayoutInfoForViewModel:self.model width:self.frame.size.width];
    if (layoutInfo.count == self.views.count) {
        for (NSInteger i = 0; i < self.views.count; ++i) {
            UIView *view = self.views[i];
            
            FSQComponentLayoutInfo info;
            [layoutInfo[i] getValue:&info];
            view.frame = info.frame;
        }
    }
}

- (void)configureWithViewModel:(FSQComponentsViewModel *)model {
    self.model = model;
    self.backgroundColor = model.backgroundColor;
    
    if ([self needsToBeResetForModel:model]) {
        [self reset];
        [self setupViewsForModel:model];
    }
    
    for (NSInteger i = 0; i < self.views.count; ++i) {
        id viewModel = [model.componentSpecifications[i] viewModel];
        [self.views[i] configureWithViewModel:viewModel];
    }
    
    [self setNeedsLayout];
}

- (BOOL)needsToBeResetForModel:(FSQComponentsViewModel *)model {
    BOOL needsToBeReset = NO;
    if (self.views.count == model.componentSpecifications.count) {
        for (NSInteger i = 0; i < self.views.count; ++i) {
            Class viewClass = [model.componentSpecifications[i] viewClass];
            if (![self.views[i] isKindOfClass:viewClass]) {
                needsToBeReset = YES;
                break;
            }
        }
    }
    else {
        needsToBeReset = YES;
    }
    return needsToBeReset;
}

- (void)reset {
    [self.views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView<FSQComposable> *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
        [[FSQComponentReuseManager shared] addViewToReusePool:view];
    }];
    self.views = nil;
}

- (void)setupViewsForModel:(FSQComponentsViewModel *)model {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (FSQComponentSpecification *specification in model.componentSpecifications) {
        UIView<FSQComposable> *view = [[FSQComponentReuseManager shared] dequeueViewForClass:specification.viewClass];
        [self addSubview:view];
        [views addObject:view];
    }
    self.views = views;
}

- (void)prepareForReuse {
    for (UIView<FSQComposable> *view in self.views) {
        [view prepareForReuse];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    for (UIView<FSQComposable> *view in self.views) {
        [view setHighlighted:highlighted animated:animated];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    for (UIView<FSQComposable> *view in self.views) {
        [view setSelected:selected animated:animated];
    }
}

- (void)dealloc {
    [self.views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView<FSQComposable> *view, NSUInteger idx, BOOL *stop) {
        [[FSQComponentReuseManager shared] addViewToReusePool:view];
    }];
}

#pragma mark - Class methods

+ (CGFloat)heightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [FSQComponentLayoutManager heightForViewModel:model width:width];
}

+ (CGFloat)estimatedHeightForViewModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    return [FSQComponentLayoutManager estimatedHeightForViewModel:model width:width];
}

@end
