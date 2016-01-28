//
//  MKCustomReadLetterView.h
//  SloveProblem
//
//  Created by moyekong on 12/23/15.
//  Copyright © 2015 morgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKCustomReadLetterViewDelegate <NSObject>

- (void)clickReadLetterView;

@end

@interface MKCustomReadLetterView : UIView

@property (nonatomic, weak) id<MKCustomReadLetterViewDelegate>delegate;

@end
