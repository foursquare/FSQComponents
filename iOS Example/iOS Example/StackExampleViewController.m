//
//  StackExampleViewController.m
//  iOS Example
//
//  Created by Cameron Mulhern on 5/11/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "StackExampleViewController.h"

#import "ComponentsCell.h"
#import "ComponentColorView.h"
#import "ComponentTextView.h"
#import "FSQComponentsView.h"
#import "FSQComponentStackView.h"

@interface StackExampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) FSQComponentsViewModel *viewModel;

@end

@implementation StackExampleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Stack Example";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.tableView registerClass:[ComponentsCell class] forCellReuseIdentifier:@"Cell"];
    
    [self loadContent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)loadContent {
    NSString *loremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    
    ComponentColorViewModel *colorModel = [[ComponentColorViewModel alloc] initWithColor:[UIColor blueColor]];
    FSQComponentSpecification *colorSpecification = [[FSQComponentSpecification alloc] initWithViewModel:colorModel viewClass:[ComponentColorView class]];
    
    ComponentTextViewModel *textModel = [[ComponentTextViewModel alloc] initWithText:loremIpsum font:[UIFont systemFontOfSize:[UIFont systemFontSize]] color:[UIColor whiteColor] multiline:YES];
    FSQComponentSpecification *textSpecification = [[FSQComponentSpecification alloc] initWithViewModel:textModel viewClass:[ComponentTextView class]];
    
    FSQComponentStackViewModel *stackModel = [[FSQComponentStackViewModel alloc] initWithBottomSpecification:colorSpecification topSpecification:textSpecification stackType:FSQComponentStackTypeStretchBottom];
    FSQComponentSpecification *stackSpecification = [[FSQComponentSpecification alloc] initWithViewModel:stackModel viewClass:[FSQComponentStackView class]];
    
    self.viewModel = [[FSQComponentsViewModel alloc] initWithComponentSpecifications:@[stackSpecification]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
