//
//  YTTableViewCell.h
//  Baby Ketten
//
//  Created by Christopher Schepman on 6/2/15.
//
//

#import <UIKit/UIKit.h>

@interface YTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
