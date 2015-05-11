//
//  FSQComponentStackView.h
//  FSQComponents
//
//  Created by Cameron Mulhern on 5/11/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSQComposable.h"

@class FSQComponentSpecification;

typedef NS_ENUM(NSUInteger, FSQComponentStackType) {
    FSQComponentStackTypeStretchBottom,
    FSQComponentStackTypeStretchTop
};

@interface FSQComponentStackViewModel : NSObject

@property (nonatomic, readonly) FSQComponentSpecification *bottomSpecification;
@property (nonatomic, readonly) FSQComponentSpecification *topSpecification;
@property (nonatomic, readonly) FSQComponentStackType stackType;

- (instancetype)initWithBottomSpecification:(FSQComponentSpecification *)bottomSpecification topSpecification:(FSQComponentSpecification *)topSpecification stackType:(FSQComponentStackType)stackType;

@end

@interface FSQComponentStackView : UIView <FSQComposable>

- (void)configureWithViewModel:(FSQComponentStackViewModel *)model;

+ (CGSize)sizeForViewModel:(FSQComponentStackViewModel *)model constrainedToSize:(CGSize)constrainedToSize;
+ (CGSize)estimatedSizeForViewModel:(FSQComponentStackViewModel *)model constrainedToSize:(CGSize)constrainedToSize;

@end
