//
//  MKReceiveLetterCell.h
//  SloveProblem
//
//  Created by moyekong on 15/12/18.
//  Copyright © 2015年 morgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKReceiveLetterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *receiveBackView;
@property (weak, nonatomic) IBOutlet UIImageView *receiveBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *receiveContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLabelWidth;

@end
