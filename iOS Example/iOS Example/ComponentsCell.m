//
//  ComponentsCell.m
//  iOS Example
//
//  Created by Cameron Mulhern on 1/14/15.
//  Copyright (c) 2015 Cameron Mulhern. All rights reserved.
//

#import "ComponentsCell.h"

#import "FSQComponentsView.h"

@interface ComponentsCell ()

@property (nonatomic) FSQComponentsView *componentsView;

@end

@implementation ComponentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.componentsView = [[FSQComponentsView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.componentsView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets insets = [[self class] paddingInsets];
    self.componentsView.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, insets);
}

- (void)configureWithModel:(FSQComponentsViewModel *)model {
    [self.componentsView configureWithViewModel:model];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.componentsView prepareForReuse];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self.componentsView setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.componentsView setSelected:selected animated:animated];
}

#pragma mark - Class methods

+ (UIEdgeInsets)paddingInsets {
    return UIEdgeInsetsZero;
}

+ (CGFloat)heightForModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    UIEdgeInsets insets = [self paddingInsets];
    CGFloat contentWidth = width - insets.left - insets.right;
    return [FSQComponentsView heightForViewModel:model width:contentWidth] + insets.top + insets.bottom;
}

+ (CGFloat)estimatedHeightForModel:(FSQComponentsViewModel *)model width:(CGFloat)width {
    UIEdgeInsets insets = [self paddingInsets];
    CGFloat contentWidth = width - insets.left - insets.right;
    return [FSQComponentsView estimatedHeightForViewModel:model width:contentWidth] + insets.top + insets.bottom;
}

@end
