//
//  ComponentPhotoView.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ComponentPhotoView.h"

#pragma mark - ComponentPhotoViewModel -

@implementation ComponentPhotoViewModel

- (instancetype)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        _image = image;
    }
    return self;
}

@end

#pragma mark - ComponentPhotoView -

@interface ComponentPhotoView ()

@property (nonatomic) ComponentPhotoViewModel *model;
@property (nonatomic) UIImageView *imageView;

@end

@implementation ComponentPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.layer.cornerRadius = 3.0;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSelected)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.imageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)configureWithViewModel:(ComponentPhotoViewModel *)model {
    self.model = model;
    self.imageView.image = model.image;
}

- (void)prepareForReuse {
    self.model = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)imageViewSelected {
    if (self.model.photoSelectedBlock) {
        self.model.photoSelectedBlock(self);
    }
}

#pragma mark - Class methods

+ (CGSize)sizeForViewModel:(ComponentPhotoViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return CGSizeMake(constrainedToSize.width, constrainedToSize.width);
}

+ (CGSize)estimatedSizeForViewModel:(ComponentPhotoViewModel *)model constrainedToSize:(CGSize)constrainedToSize {
    return [self sizeForViewModel:model constrainedToSize:constrainedToSize];
}

@end
