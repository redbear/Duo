//
//  SparkSetupVideoViewController.m
//  Pods
//
//  Created by Ido on 6/15/15.
//
//

#import "SparkSetupVideoViewController.h"
#import "SparkSetupCustomization.h"
#import <MediaPlayer/MediaPlayer.h>
#if ANALYTICS
#import <Mixpanel.h>
#endif

@interface SparkSetupVideoViewController ()
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation SparkSetupVideoViewController

/*
- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad: Allow all orientations
        return UIInterfaceOrientationMaskAll;
    } else {
        // iPhone: Allow only landscape
        return UIInterfaceOrientationMaskLandscape;
    }
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}


-(BOOL)shouldAutorotate {
    return NO;
}
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // move to super viewdidload?
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)viewWillDisappear:(BOOL)animated
{
#ifdef ANALYTICS
    [[Mixpanel sharedInstance] track:@"Device Setup: How-To video screen activity"];
#endif
    
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissPlayer];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

//-(void)viewDidAppear:(BOOL)animated
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //    self.videoViewWidth.constant = ((self.videoView.frame.size.height * 9.0)/16.0);
#ifdef ANALYTICS
    [[Mixpanel sharedInstance] timeEvent:@"Device Setup: How-To video screen activity"];
#endif
   
    
    if (self.videoFilePath)
    {
        NSArray *videoFilenameArr = [self.videoFilePath componentsSeparatedByString:@"."];
        NSString *path = [[NSBundle mainBundle] pathForResource:videoFilenameArr[0] ofType:videoFilenameArr[1]];
        
        if (path)
            self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
        if (self.videoPlayer)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.videoPlayer];
            
            self.videoPlayer.shouldAutoplay = YES;
//            self.videoPlayer.view.frame = self.view.frame;//self.videoView.bounds;
            [self.videoPlayer setFullscreen:YES animated:YES];
            
            self.videoPlayer.repeatMode = MPMovieRepeatModeNone;
//            self.videoPlayer.fullscreen = NO;
            self.videoPlayer.movieSourceType = MPMovieSourceTypeFile;
//            self.videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
            self.videoPlayer.controlStyle = MPMovieControlStyleNone;//Fullscreen;// None;
            self.videoPlayer.view.transform = CGAffineTransformConcat(self.videoPlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
            [self.videoPlayer.view setFrame: self.view.bounds];
            [self.view addSubview: self.videoPlayer.view];
            
            [self.view bringSubviewToFront:self.closeButton];
//            [self.videoView addSubview:self.videoPlayer.view]; //videoView
            
            [self.videoPlayer play];
//            self.videoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            self.videoView.layer.borderWidth = 0.5;
            
            
        }
    }
}

-(void)dismissPlayer {
    [self.videoPlayer stop];
    [self.videoPlayer.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];

    [self dismissPlayer];

}




@end
