//
//  TableViewController.m
//  iOS Example
//
//  Created by Cameron Mulhern on 3/4/15.
//  Copyright (c) 2015 foursquare. All rights reserved.
//

#import "TableViewController.h"

#import "ComponentPhotoView.h"
#import "ContentModel.h"
#import "ContentViewModel.h"
#import "ComponentsCell.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) ContentViewModel *viewModel;

@end

@implementation TableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Example";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ComponentsCell class] forCellReuseIdentifier:@"Cell"];
    
    [self loadContent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)loadContent {
    ContentModel *contentModel = [[ContentModel alloc] initWithName:@"Cameron Mulhern" message:@"Waited all morning for this breathless view. It was definitely worth it." image:[UIImage imageNamed:@"image"]];
    
    self.viewModel = [[ContentViewModel alloc] initWithContentModel:contentModel];
    
    __weak typeof(self) weak_self = self;
    self.viewModel.photoViewModel.photoSelectedBlock = ^(ComponentPhotoView *view) {
        [weak_self photoSelectedForView:view];
    };
    
    [self.tableView reloadData];
}

- (void)photoSelectedForView:(ComponentPhotoView *)view {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComponentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell configureWithModel:self.viewModel];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ComponentsCell heightForModel:self.viewModel width:tableView.frame.size.width];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
