//
//  RWDropdownMenuCell.h
//  DirtyBeijing
//
//  Created by Zhang Bin on 14-01-20.
//  Copyright (c) 2014年 Fresh-Ideas Studio. All rights reserved.
//

@import UIKit;

/**
 *  Alignment of menu item title.
 */
typedef NS_ENUM(NSInteger, RWDropdownMenuCellAlignment) {
    RWDropdownMenuCellAlignmentLeft = 0,
    RWDropdownMenuCellAlignmentCenter,
    RWDropdownMenuCellAlignmentRight,
};

@interface RWDropdownMenuCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) RWDropdownMenuCellAlignment alignment;

@end
