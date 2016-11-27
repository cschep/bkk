//
//  KamikazeViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 1/29/11.
//  Copyright Chris Schepman 2011. All rights reserved.
//

#import "KamikazeViewController.h"
#import "baby_ketten-Swift.h"

@implementation KamikazeViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.running = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textViewShouldBeginEditing:(UITextField *)textField
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:@"Bouh!"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    return NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake && !self.running) {
		[self kamikazeKetten];
	}
}

- (void)kamikazeKetten {
    self.running = YES;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @0.5;
    scale.toValue = @3.0;
    scale.duration = 1.0;
    scale.removedOnCompletion = NO;
    scale.fillMode = kCAFillModeForwards;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.values = @[@0.0, @(2 * M_PI), @0.0];
    rotate.duration = 1.0;
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    rotate.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CABasicAnimation *alphaDown = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaDown.fromValue = @1.0;
    alphaDown.toValue = @0.0;
    alphaDown.duration = 1.0;
    alphaDown.delegate = self;
    alphaDown.removedOnCompletion = NO;
    alphaDown.fillMode = kCAFillModeForwards;
    alphaDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    
    [self.kamikazeImage.layer addAnimation:scale forKey:@"move forward by scaling"];
    [self.kamikazeImage.layer addAnimation:rotate forKey:@"rotate back and forth"];
    [self.kamikazeImage.layer addAnimation:alphaDown forKey:@"alpha fade out"];
//    self.kamikazeImage.transform = CGAffineTransformIdentity;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    self.navigationController.view.alpha = 0.0;
    self.navigationController.navigationBar.hidden = NO;
    
//    SongListViewController *songListViewController = [[SongListViewController alloc] initWithSearchTerm:@"none" SearchBy:@"none" Random:YES Style:UITableViewStylePlain];

    SongListTableViewController *songList = [[SongListTableViewController alloc]
                                                initWithStyle:UITableViewStylePlain];
    songList.searchTerm = @"none";
    songList.searchBy = @"none";
    songList.random = true;

    [self.navigationController pushViewController:songList animated:NO];
    
    [UIView animateWithDuration:.7
                          delay:.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.navigationController.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self.kamikazeImage.layer removeAllAnimations];
                         self.running = NO;
                     }];
}

@end
