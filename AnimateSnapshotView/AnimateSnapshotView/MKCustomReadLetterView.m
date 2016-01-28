//
//  MKCustomReadLetterView.m
//  SloveProblem
//
//  Created by moyekong on 12/23/15.
//  Copyright © 2015 morgan. All rights reserved.
//

#import "MKCustomReadLetterView.h"

@interface MKCustomReadLetterView ()

@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentDisplayTextView;
@property (weak, nonatomic) IBOutlet UILabel *senderTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation MKCustomReadLetterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"MKCustomReadLetterView" owner:self options:nil] lastObject];
    self.frame = frame;
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentDisplayTextView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self addGestureRecognizer:tapOnView];
        
        UITapGestureRecognizer *tapOnBackView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
        [self.backView addGestureRecognizer:tapOnBackView];
    }
    return self;
}

- (void)tapView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickReadLetterView)]) {
        [self.delegate clickReadLetterView];
    }
}
- (IBAction)closeView:(id)sender {
    [self tapView:nil];
}

- (void)tapBackView:(id)sender {

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
