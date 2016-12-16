//
//  RWDropdownMenu.h
//  DirtyBeijing
//
//  Created by Zhang Bin on 14-01-20.
//  Copyright (c) 2014年 Fresh-Ideas Studio. All rights reserved.
//

@import UIKit;
#import "RWDropdownMenuCell.h"

/**
 *  Background style for the menu.
 */
typedef NS_ENUM(NSInteger, RWDropdownMenuStyle) {
    /**
     *  Vertical gradient background from black to semi-transparent.
     */
    RWDropdownMenuStyleBlackGradient = 0,
    /**
     *  UIToolbar-like translucent background.
     */
    RWDropdownMenuStyleTranslucent,
    /**
     *  Pure white, used only when presenting inside a popover on iPad.
     */
    RWDropdownMenuStyleWhite
};



/**
 *  Description of a menu item.
 */
@interface RWDropdownMenuItem : NSObject

/**
 *  Item title.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 *  Attributed version of the title (for use with custom fonts, colors etc...)
 */

@property (nonatomic, copy, readonly) NSAttributedString *attributedText;

/**
 *  Item action block.
 */
@property (nonatomic, copy, readonly) void (^action)(void);

/**
 *  Item image. Not displayed when menu is center aligned.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 *  Creates a menu item with given title, image and action.
 */
+ (instancetype)itemWithText:(NSString *)text image:(UIImage *)image action:(void (^)(void))action;
+ (instancetype)itemWithAttributedText:(NSAttributedString *)attributedText image:(UIImage *)image action:(void (^)(void))action;

@end




@interface RWDropdownMenu : UIViewController

/**
 *  Background of the menu.
 */
@property (nonatomic, strong, readonly) UIView *backgroundView;

/**
 *  Collection view for displaying item cells.
 */
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/**
 *  Show a fullscreen dropdown menu from a navigation bar item.
 *
 *  @param viewController the view controller showing this menu.
 *  @param items          NSArray of RWDropdownMenuItem
 *  @param align          menu item title alignment.
 *  @param style          menu background style.
 *  @param navBarImage    if set, this image will be displayed at the same position as the navigation bar item.
 *  @param completion     completion block after the presenting animation is done.
 */
+ (instancetype)presentFromViewController:(UIViewController *)viewController
                                withItems:(NSArray *)items
                                    align:(RWDropdownMenuCellAlignment)align
                                    style:(RWDropdownMenuStyle)style
                              navBarImage:(UIImage *)navBarImage
                               completion:(void (^)(void))completion;

/**
 *  Show a menu from a bar button item in a popover.
 *  The menu is shown also inside a popover.
 *  Item titles are always left-aligned.
 *
 *  @param barButtonItem the bar item to activate this menu.
 *  @param items         menu items.
 *  @param completion    completion block after the presenting animation is done.
 */
+ (void)presentInPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                                withItems:(NSArray *)items
                               completion:(void (^)(void))completion;

@end
