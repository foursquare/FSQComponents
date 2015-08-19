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

- (instancetype)init {
    [NSException raise:@"FSQComponentsViewModel" format:@"init has not been implemented."];
    return [self initWithComponentSpecifications:nil];
}

- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications {
    return [self initWithComponentSpecifications:componentSpecifications smartInsetsAppliesToEdges:YES];
}

- (instancetype)initWithComponentSpecifications:(NSArray *)componentSpecifications smartInsetsAppliesToEdges:(BOOL)smartInsetsAppliesToEdges {
    if ((self = [super init])) {
        _componentSpecifications = [componentSpecifications copy];
        _smartInsetsAppliesToEdges = smartInsetsAppliesToEdges;
        _userInteractionEnabled = YES;
        
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
    self.userInteractionEnabled = model.userInteractionEnabled;
    
    if ([self needsToBeResetForModel:model]) {
        [self reset];
        [self setupViewsForModel:model];
    }
    else {
        for (UIView<FSQComposable> *view in self.views) {
            [view prepareForReuse];
        }
    }
    
    for (NSInteger i = 0; i < self.views.count; ++i) {
        id viewModel = [model.componentSpecifications[i] viewModel];
        UIView<FSQComposable> *view = self.views[i];
        [view configureWithViewModel:viewModel];
        [view setNeedsLayout];
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

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [FSQComponentLayoutManager sizeForViewModel:model constrainedToSize:constrainedToSize];
}

+ (CGSize)estimatedSizeForViewModel:(FSQComponentsViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [FSQComponentLayoutManager estimatedSizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
