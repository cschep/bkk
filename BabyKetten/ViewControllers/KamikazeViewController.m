//
//  KamikazeViewController.m
//  Baby Ketten
//
//  Created by Christopher Schepman on 1/29/11.
//  Copyright Chris Schepman 2011. All rights reserved.
//

#import "KamikazeViewController.h"
#import "BabyKetten-Swift.h"

@implementation KamikazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.running = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    self.navigationController.view.alpha = 0.0;
    self.navigationController.navigationBar.hidden = NO;
    
    SongListTableViewController *songList = [[SongListTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
