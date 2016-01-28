//
//  LetterView.h
//  AnimateSnapshotView
//
//  Created by mokong on 16/1/27.
//  Copyright © 2016年 mokong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LetterViewDelegate <NSObject>

- (void)letterViewSelectedIndexPath:(NSIndexPath *)indexPath
                               cell:(UITableViewCell *)cell
                        animateView:(UIView *)animateView;

@end

@interface LetterView : UIView

@property (nonatomic, weak) id<LetterViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
