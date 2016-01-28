//
//  MKSentLetterCell.m
//  SloveProblem
//
//  Created by moyekong on 15/12/18.
//  Copyright © 2015年 morgan. All rights reserved.
//

#import "MKSentLetterCell.h"

@implementation MKSentLetterCell

- (void)awakeFromNib {
    // Initialization code
    
    self.seperatorLabelWidth.constant = 0.5;
    self.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
