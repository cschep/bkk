//
//  KamikazeViewController.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 1/29/11.
//  Copyright Chris Schepman 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KamikazeViewController : UIViewController <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *kamikazeImageView;

@property BOOL running;

- (void)kamikazeKetten;

@end
