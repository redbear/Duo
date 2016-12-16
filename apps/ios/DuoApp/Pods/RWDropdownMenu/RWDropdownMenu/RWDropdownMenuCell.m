//
//  RWDropdownMenuCell.m
//  DirtyBeijing
//
//  Created by Zhang Bin on 14-01-20.
//  Copyright (c) 2014年 Fresh-Ideas Studio. All rights reserved.
//

#import "RWDropdownMenuCell.h"

@implementation RWDropdownMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textLabel = [UILabel new];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textLabel];
        self.imageView = [UIImageView new];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
        self.backgroundColor = [UIColor clearColor];
        self.imageView.image = nil;
        self.selectedBackgroundView = [UIView new];
        
    }
    return self;
}

- (UIColor *)inversedTintColor
{
    CGFloat white = 0, alpha = 0;
    [self.tintColor getWhite:&white alpha:&alpha];
    return [UIColor colorWithWhite:1.2 - white alpha:alpha];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    self.textLabel.textColor = self.tintColor;
    self.selectedBackgroundView.backgroundColor = self.tintColor;
    self.textLabel.highlightedTextColor = [self inversedTintColor];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.imageView.tintColor = [self inversedTintColor];
        NSUInteger len = [self.textLabel.attributedText length];
        if (len > 0) {
            NSMutableAttributedString *attrStr = [self.textLabel.attributedText mutableCopy];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[self inversedTintColor] range:NSMakeRange(0, len)];
            [self.textLabel setAttributedText:attrStr];
        }
    }
    else
    {
        self.imageView.tintColor = self.tintColor;
    }
}

- (void)setAlignment:(RWDropdownMenuCellAlignment)alignment
{
    _alignment = alignment;
    self.imageView.hidden = (alignment == RWDropdownMenuCellAlignmentCenter);
    switch (_alignment) {
        case RWDropdownMenuCellAlignmentLeft:
            self.textLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case RWDropdownMenuCellAlignmentCenter:
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case RWDropdownMenuCellAlignmentRight:
            self.textLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    NSDictionary *views = @{@"text":self.textLabel, @"image":self.imageView};
    
    // vertical centering
    for (UIView *v in [views allValues])
    {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    
    CGFloat margin = 20;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        margin = 25;
    }
    
    // horizontal
    NSString *vfs = nil;
    switch (self.alignment) {
        case RWDropdownMenuCellAlignmentCenter:
            vfs = @"H:|[text]|";
            break;
            
        case RWDropdownMenuCellAlignmentLeft:
            vfs = @"H:[image]-(15)-[text]|";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:margin]];
            break;
            
        case RWDropdownMenuCellAlignmentRight:
            vfs = @"H:|[text]-(15)-[image]";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-margin]];
            break;
            
        default:
            break;
    }
    
    [self.imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfs options:0 metrics:nil views:views]];
}

@end
