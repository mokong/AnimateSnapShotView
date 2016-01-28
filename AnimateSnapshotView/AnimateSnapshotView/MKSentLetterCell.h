//
//  MKSentLetterCell.h
//  SloveProblem
//
//  Created by moyekong on 15/12/18.
//  Copyright © 2015年 morgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKSentLetterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *sentBackView;
@property (weak, nonatomic) IBOutlet UIImageView *sentBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *sentContentLabel; // 发送内容
@property (weak, nonatomic) IBOutlet UILabel *senderLabel; // 发送者
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLabelWidth;


@end
