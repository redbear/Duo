//
//  RWDropdownMenu.m
//  DirtyBeijing
//
//  Created by Zhang Bin on 14-01-20.
//  Copyright (c) 2014年 Fresh-Ideas Studio. All rights reserved.
//

#import "RWDropdownMenu.h"
#import "RWDropdownMenuCell.h"
#import "RWDropdownMenuTransitionController.h"

@interface RWDropdownMenuBackgroundView : UIView

@end

@implementation RWDropdownMenuBackgroundView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *layer = (CAGradientLayer *)self.layer;
        layer.colors = @[
                         (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                         (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor],
                         ];
    }
    return self;
}

@end



@interface RWDropdownMenuItem ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, copy) void (^action)(void);
@property (nonatomic, strong) UIImage *image;

@end

@implementation RWDropdownMenuItem

+ (instancetype)itemWithText:(NSString *)text image:(UIImage *)image action:(void (^)(void))action
{
    RWDropdownMenuItem *item = [self new];
    item.text = text;
    item.image = image;
    item.action = action;
    return item;
}

+ (instancetype)itemWithAttributedText:(NSAttributedString *)attributedText image:(UIImage *)image action:(void (^)(void))action {
    RWDropdownMenuItem *item = [self new];
    item.attributedText = attributedText;
    item.image = image;
    item.action = action;
    return item;
}

@end


@interface RWDropdownMenuPopoverHelper : NSObject <UIPopoverControllerDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation RWDropdownMenuPopoverHelper

+ (instancetype)sharedInstance
{
    static RWDropdownMenuPopoverHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RWDropdownMenuPopoverHelper new];
    });
    return instance;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}

@end


static NSString * const CellId = @"RWDropdownMenuCell";

@interface RWDropdownMenu () <UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) RWDropdownMenuCellAlignment alignment;
@property (nonatomic, strong) UIImage *navBarImage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) RWDropdownMenuStyle style;

@property (nonatomic, strong) UIToolbar *blurView;
@property (nonatomic, strong) RWDropdownMenuBackgroundView *gradientBackground;
@property (nonatomic, strong) UIView *whiteBackground;

@property (nonatomic, strong) RWDropdownMenuTransitionController *transitionController;

@property (nonatomic, assign) BOOL isInPopover;

- (void)enterTheStageWithCompletion:(void (^)(void))completion;
- (void)leaveTheStageWithCompletion:(void (^)(void))completion;

@end

@implementation RWDropdownMenu

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dismiss:(id)sender
{
    UIViewController *vc = [self presentingViewController];
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        vc = [vc performSelector:@selector(topViewController)];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [vc.view setNeedsLayout];
        if ([vc respondsToSelector:@selector(collectionView)])
        {
            UICollectionView *collectionView = [vc performSelector:@selector(collectionView)];
            [collectionView.collectionViewLayout invalidateLayout];
        }
    }];
}

- (UIView *)backgroundView
{
    switch (self.style) {
        case RWDropdownMenuStyleBlackGradient:
            return self.gradientBackground;
            
        case RWDropdownMenuStyleTranslucent:
            return self.blurView;
            
        case RWDropdownMenuStyleWhite:
            return self.whiteBackground;
            
        default:
            return nil;
    }
}

- (UIToolbar *)blurView {
    if (!_blurView) {
        _blurView = [[UIToolbar alloc] initWithFrame:self.view.bounds];
        _blurView.autoresizingMask = 0;
        _blurView.barStyle = UIBarStyleBlackTranslucent;
        [self.view insertSubview:_blurView atIndex:0];
    }
    return _blurView;
}

- (RWDropdownMenuBackgroundView *)gradientBackground {
    if (!_gradientBackground) {
        _gradientBackground = [[RWDropdownMenuBackgroundView alloc] initWithFrame:self.view.bounds];
        _gradientBackground.autoresizingMask = 0;
        [self.view insertSubview:_gradientBackground atIndex:0];
    }
    return _gradientBackground;
}

- (UIView *)whiteBackground {
    if (!_whiteBackground) {
        _whiteBackground = [[UIView alloc] initWithFrame:self.view.bounds];
        _whiteBackground.autoresizingMask = 0;
        _whiteBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        [self.view insertSubview:_whiteBackground atIndex:0];
    }
    return _whiteBackground;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (self.style != RWDropdownMenuStyleWhite) {
        self.view.tintColor = [UIColor whiteColor];
    } else {
        self.view.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.autoresizingMask = 0;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.clipsToBounds = YES;
    [self.collectionView registerClass:[RWDropdownMenuCell class] forCellWithReuseIdentifier:CellId];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundView = [UIView new];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView.userInteractionEnabled = YES;
    [self.collectionView.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)]];
    
    [self prepareNavigationItem];
    
    self.backgroundView.alpha = 0;
    self.collectionView.hidden = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    CGFloat barHeight = [self topLayoutGuide].length;
    self.backgroundView.frame = self.view.bounds;
    self.collectionView.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(barHeight, 0, 0, 0));
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)prepareNavigationItem
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:self.navBarImage style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    if (self.alignment == RWDropdownMenuCellAlignmentLeft)
    {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if (self.alignment == RWDropdownMenuCellAlignmentRight)
    {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (CGSize)preferredContentSize
{
    CGSize size = CGSizeMake(320, 0);
    size.height = [self itemHeight] * self.items.count;
    if (self.items.count > 0)
    {
        size.height += [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout minimumLineSpacingForSectionAtIndex:0] * (self.items.count - 1);
        UIEdgeInsets insets = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout insetForSectionAtIndex:0];
        size.height += insets.top + insets.bottom;
    }
    
    return size;
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWDropdownMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    
    cell.tintColor = self.view.tintColor;
    
    RWDropdownMenuItem *item = self.items[indexPath.row];
    if (item.text && item.text.length > 0) {
        cell.textLabel.text = item.text;
    }
    else if (item.attributedText && item.attributedText.length > 0) {
        cell.textLabel.attributedText = item.attributedText;
    }
    cell.imageView.image = item.image;
    cell.alignment = self.alignment;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    double delayInSeconds = 0.15;
    RWDropdownMenuItem *item = self.items[indexPath.row];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.isInPopover)
        {
            [[RWDropdownMenuPopoverHelper sharedInstance].popover dismissPopoverAnimated:YES];
            if (item.action)
            {
                item.action();
            }
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (item.action)
            {
                double delayInSeconds = 0.15;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    item.action();
                });
            }
        }];
    });
}

#pragma mark - layout

- (CGFloat)itemHeight
{
    return 44;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, [self itemHeight]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

#pragma mark - presenting

- (void)presentFromViewController:(UIViewController *)viewController completion:(void (^)(void))completion
{
    [self prepareNavigationItem];
    [viewController presentViewController:self animated:YES completion:completion];
}

+ (instancetype)presentFromViewController:(UIViewController *)viewController
                                withItems:(NSArray *)items
                                    align:(RWDropdownMenuCellAlignment)align
                                    style:(RWDropdownMenuStyle)style
                              navBarImage:(UIImage *)navBarImage
                               completion:(void (^)(void))completion
{
    RWDropdownMenu *menu = [[RWDropdownMenu alloc] initWithNibName:nil bundle:nil];
    menu.style = style;
    menu.alignment = align;
    menu.items = items;
    menu.navBarImage = navBarImage;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    nav.view.tintColor = menu.view.tintColor;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent = YES;
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    nav.navigationBar.userInteractionEnabled = YES;
    [nav.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:menu action:@selector(dismiss:)]];
    
    nav.transitioningDelegate = menu;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    [viewController presentViewController:nav animated:YES completion:^{
        if (completion)
        {
            completion();
        }
    }];
    return menu;
}

+ (void)presentInPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                                withItems:(NSArray *)items
                               completion:(void (^)(void))completion
{
    RWDropdownMenuPopoverHelper *helper = [RWDropdownMenuPopoverHelper sharedInstance];
    if (helper.popover)
    {
        [helper.popover dismissPopoverAnimated:YES];
        helper.popover = nil;
        return;
    }
    
    RWDropdownMenu *menu = [[RWDropdownMenu alloc] initWithNibName:nil bundle:nil];
    menu.style = RWDropdownMenuStyleWhite;
    menu.alignment = RWDropdownMenuCellAlignmentLeft;
    menu.items = items;
    menu.navBarImage = nil;
    menu.isInPopover = YES;
    
    helper.popover = [[UIPopoverController alloc] initWithContentViewController:menu];
    helper.popover.delegate = helper;
    [helper.popover presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [menu enterTheStageWithCompletion:^{
            }];
        }];
    }];
}

#pragma mark - transition

- (RWDropdownMenuTransitionController *)transitionController
{
    if (!_transitionController)
    {
        _transitionController = [RWDropdownMenuTransitionController new];
    }
    return _transitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionController.isDismissing = YES;
    return self.transitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionController.isDismissing = NO;
    return self.transitionController;
}

- (CGAffineTransform)offStageTransformForItemAtIndex:(NSInteger)idx negative:(BOOL)negative
{
    const CGFloat maxTranslation = 200;
    const CGFloat minTranslation = 100;
    CGFloat translation = maxTranslation - (maxTranslation - minTranslation) * ((CGFloat)idx / self.items.count);
    if (negative)
    {
        translation = -translation;
    }
    
    switch (self.alignment) {
        case RWDropdownMenuCellAlignmentLeft:
            return CGAffineTransformMakeTranslation(translation, 0);
            
        case RWDropdownMenuCellAlignmentRight:
            return CGAffineTransformMakeTranslation(-translation, 0);
            
        case RWDropdownMenuCellAlignmentCenter:
            return CGAffineTransformMakeTranslation(0, -translation);
            
        default:
            return CGAffineTransformIdentity;
    }
}

- (void)enterTheStageWithCompletion:(void (^)(void))completion
{
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        cell.transform = [self offStageTransformForItemAtIndex:idx negative:NO];
        cell.alpha = 0;
    }
    
    self.collectionView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        // [UIView animateWithDuration:0.3 delay:0.02 * idx options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat delay = 0.02 * idx;
        if (!self.isInPopover)
        {
            delay += 0.05; // wait for backgroundView
        }
        [UIView animateWithDuration:0.8 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0 animations:^{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (idx + 1 == self.items.count && completion)
            {
                completion();
            }
        }];
    }
}

- (void)leaveTheStageWithCompletion:(void (^)(void))completion
{
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        [UIView animateWithDuration:0.3 delay:0.02 * idx options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.items.count - idx - 1 inSection:0]];
            cell.transform = [self offStageTransformForItemAtIndex:idx negative:YES];
            cell.alpha = 0;
            if (idx + 1 == self.items.count)
            {
                self.backgroundView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            if (idx + 1 == self.items.count && completion)
            {
                completion();
            }
        }];
    }
}

@end
