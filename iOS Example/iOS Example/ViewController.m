//
//  ViewController.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "ViewController.h"

#import "ComponentPhotoView.h"
#import "ContentModel.h"
#import "ContentViewModel.h"

@interface ViewController ()

@property (nonatomic) ContentViewModel *viewModel;
@property (nonatomic) FSQComponentsView *componentsView;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Example";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.componentsView = [[FSQComponentsView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.componentsView];
    
    [self loadContent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = [FSQComponentsView sizeForViewModel:self.viewModel constrainedToSize:self.view.frame.size].height;
    self.componentsView.frame = CGRectMake(0.0, self.topLayoutGuide.length, width, height);
}

- (void)loadContent {
    ContentModel *contentModel = [[ContentModel alloc] initWithName:@"Cameron Mulhern" message:@"Waited all morning for this breathless view. It was definitely worth it." image:[UIImage imageNamed:@"image"]];
    
    self.viewModel = [[ContentViewModel alloc] initWithContentModel:contentModel];
    
    __weak typeof(self) weak_self = self;
    self.viewModel.photoViewModel.photoSelectedBlock = ^(ComponentPhotoView *view) {
        [weak_self photoSelectedForView:view];
    };
    
    [self.componentsView configureWithViewModel:self.viewModel];
    [self.view setNeedsLayout];
}

- (void)photoSelectedForView:(ComponentPhotoView *)view {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
