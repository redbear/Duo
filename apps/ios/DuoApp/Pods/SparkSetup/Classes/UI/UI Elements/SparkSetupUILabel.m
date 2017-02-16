//
//  SparkSetupUILabel.m
//  teacup-ios-app
//
//  Created by Ido on 1/16/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkSetupUILabel.h"
#import "SparkSetupCustomization.h"
@implementation SparkSetupUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)replacePredefinedText
{
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{device}" withString:[SparkSetupCustomization sharedInstance].deviceName];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{brand}" withString:[SparkSetupCustomization sharedInstance].brandName];
    NSString *orgName = [SparkSetupCustomization sharedInstance].organizationName;
    if (orgName)
        self.text = [self.text stringByReplacingOccurrencesOfString:@"{org name}" withString:orgName];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{color}" withString:[SparkSetupCustomization sharedInstance].listenModeLEDColorName];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{mode button}" withString:[SparkSetupCustomization sharedInstance].modeButtonName];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{network prefix}" withString:[SparkSetupCustomization sharedInstance].networkNamePrefix];
    self.text = [self.text stringByReplacingOccurrencesOfString:@"{product}" withString:[SparkSetupCustomization sharedInstance].productName];

    //    self.text = [self.text stringByReplacingOccurrencesOfString:@"{app name}" withString:[SparkSetupCustomization sharedInstance].appName];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        [self replacePredefinedText];
        [self setType:self.type];
        return self;
    }
    return nil;
    
}

-(void)setType:(NSString *)type
{
    if ((type) && ([type isEqualToString:@"bold"]))
    {
        self.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].boldTextFontName size:self.font.pointSize+[SparkSetupCustomization sharedInstance].fontSizeOffset];
        self.textColor = [SparkSetupCustomization sharedInstance].normalTextColor;
    }
    else if ((type) && ([type isEqualToString:@"header"]))
    {
        self.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].headerTextFontName size:self.font.pointSize+[SparkSetupCustomization sharedInstance].fontSizeOffset];
        self.textColor = [SparkSetupCustomization sharedInstance].normalTextColor;
    }
    else
    {
        self.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].normalTextFontName size:self.font.pointSize+[SparkSetupCustomization sharedInstance].fontSizeOffset];
        self.textColor = [SparkSetupCustomization sharedInstance].normalTextColor;
        
    }
    [self replacePredefinedText];
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
  
}

@end
