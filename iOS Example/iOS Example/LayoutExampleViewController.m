//
//  LayoutExampleViewController.m
//  iOS Example
//
//  Created by Cameron Mulhern on 4/16/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "LayoutExampleViewController.h"

#import "ComponentsCell.h"
#import "FSQComponentButton.h"
#import "FSQComponentsView.h"

@interface LayoutExampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

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
    
    NSMutableArray *specifications = [[NSMutableArray alloc] init];
    for (NSString *token in [loremIpsum componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
        FSQComponentButtonModel *model = [[FSQComponentButtonModel alloc] initWithImage:nil title:token titleColor:[UIColor whiteColor]];
        model.font = [UIFont systemFontOfSize:12.0];
        model.backgroundColor = [UIColor blueColor];
        model.cornerRadius = 3.0;
        model.horizontalPadding = 10.0;
        
        FSQComponentSpecification *specification = [[FSQComponentSpecification alloc] initWithViewModel:model viewClass:[UIButton class]];
        specification.layoutType = FSQComponentLayoutTypeFixed;
        specification.widthConstraint = [UIButton sizeForViewModel:model constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        [specifications addObject:specification];
    }
    
    self.viewModel = [[FSQComponentsViewModel alloc] initWithComponentSpecifications:specifications];
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
