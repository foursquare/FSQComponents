//
//  ComponentColorView.m
//  iOS Example
//
//  Created by Cameron Mulhern on 5/11/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "ComponentColorView.h"

@implementation ComponentColorViewModel

- (instancetype)initWithColor:(UIColor *)color {
    if ((self = [super init])) {
        _color = color;
    }
    return self;
}

@end

@implementation ComponentColorView

- (void)configureWithViewModel:(ComponentColorViewModel *)model {
    self.backgroundColor = model.color;
}

- (void)prepareForReuse {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

+ (CGSize)sizeForViewModel:(ComponentColorViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return CGSizeMake(constrainedToSize.width, model.desiredHeight);
}

+ (CGSize)estimatedSizeForViewModel:(ComponentColorViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
