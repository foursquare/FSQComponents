//
//  ContentViewModel.h
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "FSQComponentsView.h"

@class ComponentPhotoViewModel;
@class ComponentTextViewModel;
@class ContentModel;

@interface ContentViewModel : FSQComponentsViewModel

@property (nonatomic, readonly) ComponentTextViewModel *titleViewModel;
@property (nonatomic, readonly) ComponentPhotoViewModel *photoViewModel;
@property (nonatomic, readonly) ComponentTextViewModel *messageViewModel;

- (instancetype)initWithContentModel:(ContentModel *)contentModel;

@end
