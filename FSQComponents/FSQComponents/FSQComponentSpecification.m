//
//  FSQComponentSpecification.m
//  FSQComponents
//
//  Created by Cameron Mulhern on 3/20/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentSpecification.h"

#import "FSQComposable.h"
#import "FSQComponentsView.h"

@implementation FSQComponentSpecification

- (instancetype)init {
    [NSException raise:@"FSQComponentSpecification" format:@"init has not been implemented."];
    return [self initWithViewModel:nil viewClass:nil];
}

- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass {
    return [self initWithViewModel:viewModel viewClass:viewClass insets:kFSQComponentSmartInsets];
}

- (instancetype)initWithViewModel:(id)viewModel viewClass:(Class)viewClass insets:(UIEdgeInsets)insets {
    if ((self = [super init])) {
        NSAssert([viewClass conformsToProtocol:@protocol(FSQComposable)] || IS_KIND(viewClass, UIButton), @"Attempting to create a FSQComponentSpecification with an invalid viewClass.");
        _viewModel = viewModel;
        _viewClass = viewClass;
        _insets = insets;
        
        _growthFactor = 1.0;
    }
    return self;
}

@end
