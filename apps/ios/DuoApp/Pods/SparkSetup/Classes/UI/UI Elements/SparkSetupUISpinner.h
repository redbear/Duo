//
//  SparkSetupUISpinner.h
//  teacup-ios-app
//
//  Created by Ido on 1/27/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SparkSetupUISpinner : UIImageView
@property (nonatomic, strong) NSString *type; // "foreground" (colored on a view) or "background" (white on a button)

-(void)startAnimating;
-(void)stopAnimating;
-(instancetype)initWithType:(NSString *)type;

@end
