//
//  ContentViewModel.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ContentViewModel.h"

#import "ComponentHorizontalRuleView.h"
#import "ComponentPhotoView.h"
#import "ComponentTextView.h"
#import "ContentModel.h"
#import "FSQComponentLabelModel.h"

#define kTitleFont [UIFont systemFontOfSize:18.0]
#define kTitleColor [UIColor colorWithRed:0.0 green:170.0/255.0 blue:1.0 alpha:1.0]

#define kMessageFont [UIFont systemFontOfSize:14.0]
#define kMessageColor [UIColor colorWithWhite:0.1 alpha:1.0]

@implementation ContentViewModel

- (instancetype)initWithContentModel:(ContentModel *)contentModel {
    FSQComponentSpecification *titleSpecification = [[self class] newTitleSpecificationForContentModel:contentModel];
    FSQComponentSpecification *ruleSpecification = [[self class] newHorizontalRuleSpecificationForContentModel:contentModel];
    FSQComponentSpecification *photoSpecification = [[self class] newPhotoSpecificationForContentModel:contentModel];
    FSQComponentSpecification *messageSpecification = [[self class] newMessageSpecificationForContentModel:contentModel];
    
    NSArray *specifications = @[titleSpecification, ruleSpecification, photoSpecification, messageSpecification];
    if ((self = [super initWithComponentSpecifications:specifications])) {
        _titleViewModel = titleSpecification.viewModel;
        _photoViewModel = photoSpecification.viewModel;
        _messageViewModel = messageSpecification.viewModel;
    }
    return self;
}

+ (FSQComponentSpecification *)newTitleSpecificationForContentModel:(ContentModel *)contentModel {
    FSQComponentLabelModel *model = [[FSQComponentLabelModel alloc] initWithText:contentModel.name font:kTitleFont textColor:kTitleColor];
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[UILabel class]];
    specification.layoutType = FSQComponentLayoutTypeDynamic;
    return specification;
}

+ (FSQComponentSpecification *)newHorizontalRuleSpecificationForContentModel:(ContentModel *)contentModel {
    ComponentHorizontalRuleViewModel *model = [[ComponentHorizontalRuleViewModel alloc] init];
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[ComponentHorizontalRuleView class]];
    specification.layoutType = FSQComponentLayoutTypeFull;
    return specification;
}

+ (FSQComponentSpecification *)newPhotoSpecificationForContentModel:(ContentModel *)contentModel {
    ComponentPhotoViewModel *model = [[ComponentPhotoViewModel alloc] initWithImage:contentModel.image];
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[ComponentPhotoView class]];
    specification.layoutType = FSQComponentLayoutTypeFixed;
    specification.widthPercentConstraint = 0.3;
    return specification;
}

+ (FSQComponentSpecification *)newMessageSpecificationForContentModel:(ContentModel *)contentModel {
    ComponentTextViewModel *model = [[ComponentTextViewModel alloc] initWithText:contentModel.message font:kMessageFont color:kMessageColor multiline:YES];
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[ComponentTextView class]];
    specification.layoutType = FSQComponentLayoutTypeFlexible;
    return specification;
}

@end
