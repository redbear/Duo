//
//  SparkSetupUISpinner.m
//  teacup-ios-app
//
//  Created by Ido on 1/27/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkSetupUISpinner.h"
#import "SparkSetupCustomization.h"
#import "SparkSetupMainController.h"

@implementation SparkSetupUISpinner

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setType:(NSString *)type
{
    if ((type) && ([type isEqualToString:@"foreground"]))
    {
//        self.image = [UIImage imageNamed:@"spinner_big" inBundle:[SparkSetupMainController getResourcesBundle] compatibleWithTraitCollection:nil]; // TODO: make iOS7 compatible
        self.image = [SparkSetupMainController loadImageFromResourceBundle:@"spinner_big"];
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tintColor = [SparkSetupCustomization sharedInstance].elementBackgroundColor;
    }
    else
    {
//        self.image = [UIImage imageNamed:@"spinner" inBundle:[SparkSetupMainController getResourcesBundle] compatibleWithTraitCollection:nil]; // TODO: make iOS7 compatible
        self.image = [SparkSetupMainController loadImageFromResourceBundle:@"spinner"];
//        NSLog(@"spinner: %@",self.image);
    }
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}


-(void)startAnimating
{
        self.hidden = NO;
        CABasicAnimation *rotation;
        rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = [NSNumber numberWithFloat:0];
        rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
        rotation.duration = 1.11; // Speed
        rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        [self.layer addAnimation:rotation forKey:@"Spin"];
}

                   
                   

-(void)stopAnimating
{
    self.hidden = YES;
    [self.layer removeAllAnimations];
}


-(instancetype)initWithType:(NSString *)type
{
    if (self = [super init])
    {
        [self setType:type];
        
        return self;
    }
    return nil;
}


@end
