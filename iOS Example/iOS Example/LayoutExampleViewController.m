//
//  LayoutExampleViewController.m
//  iOS Example
//
//  Created by Cameron Mulhern on 4/16/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "LayoutExampleViewController.h"

#import "ComponentsCell.h"
#import "FSQComponentButtonModel.h"
#import "FSQComponentLabelModel.h"
#import "FSQComponentsView.h"

typedef NS_ENUM(NSUInteger, ContentMode) {
    ContentModeButtons,
    ContentModeLabels
};

@interface LayoutExampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) UIView *tableViewHeader;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) ContentMode contentMode;
@property (nonatomic) FSQComponentsViewModel *viewModel;

@end

@implementation LayoutExampleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Layout Example";
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
    
    self.tableViewHeader = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = self.tableViewHeader;
    
    NSArray *items = @[@"Buttons", @"Labels"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged) forControlEvents:UIControlEventValueChanged];
    [self.tableViewHeader addSubview:self.segmentedControl];
    
    [self loadContent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize size = [self.segmentedControl sizeThatFits:self.view.bounds.size];
    self.tableViewHeader.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, size.height + 10.0);
    self.segmentedControl.frame = CGRectMake(10.0, 10.0, self.tableViewHeader.frame.size.width - 20.0, size.height);
    self.tableView.tableHeaderView = self.tableViewHeader;
    
    self.tableView.frame = self.view.bounds;
}

- (void)loadContent {
    NSString *loremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    
    NSMutableArray *specifications = [[NSMutableArray alloc] init];
    for (NSString *token in [loremIpsum componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
        switch (self.contentMode) {
            case ContentModeButtons:
                [specifications addObject:[self buttonComponentSpecificationForToken:token]];
                break;
            case ContentModeLabels:
                [specifications addObject:[self labelComponentSpecificationForToken:token]];
                break;
        }
    }
    
    self.viewModel = [[FSQComponentsViewModel alloc] initWithComponentSpecifications:specifications];
    [self.tableView reloadData];
}

- (FSQComponentSpecification *)buttonComponentSpecificationForToken:(NSString *)token {
    FSQComponentButtonModel *model = [[FSQComponentButtonModel alloc] initWithImage:nil title:token titleColor:[UIColor whiteColor]];
    model.font = [UIFont systemFontOfSize:12.0];
    model.backgroundColor = [UIColor blueColor];
    model.cornerRadius = 3.0;
    model.horizontalPadding = 10.0;
    
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[UIButton class]];
    specification.layoutType = FSQComponentLayoutTypeFixed;
    specification.widthConstraint = [UIButton sizeForViewModel:model constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    return specification;
}

- (FSQComponentSpecification *)labelComponentSpecificationForToken:(NSString *)token {
    FSQComponentLabelModel *model = [[FSQComponentLabelModel alloc] initWithText:token];
    model.textColor = [UIColor blackColor];
    
    FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[UILabel class]];
    specification.layoutType = FSQComponentLayoutTypeFixed;
    specification.widthConstraint = [UILabel sizeForViewModel:model constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    return specification;
}

- (void)segmentedControlChanged {
    self.contentMode = (self.segmentedControl.selectedSegmentIndex == 0) ? ContentModeButtons : ContentModeLabels;
    [self loadContent];
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
