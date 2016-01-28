//
//  LetterView.m
//  AnimateSnapshotView
//
//  Created by mokong on 16/1/27.
//  Copyright © 2016年 mokong. All rights reserved.
//

#import "LetterView.h"
#import "MKReceiveLetterCell.h"
#import "MKSentLetterCell.h"

@interface LetterView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LetterView

static CGFloat const tableViewRowH = 100.0;
static CGFloat const tableViewHeaderH = 0.1;
static CGFloat const tableViewFooterH = 0.1;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    if (self.tableView) {
        return;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    
    // eg: 注册要在add之前，否则当动态计算高度时，会出现崩溃
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MKSentLetterCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MKSentLetterCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MKReceiveLetterCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MKReceiveLetterCell class])];
    
    [self addSubview:self.tableView];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self setupSubviews];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableViewRowH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableViewHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return tableViewFooterH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), tableViewHeaderH)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), tableViewFooterH)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray) {
        NSInteger rowNumber = indexPath.row;
        if (rowNumber%2 == 0) {
            MKSentLetterCell *cell1 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MKSentLetterCell class]) forIndexPath:indexPath];
            
            
            return cell1;
        }
        else {
            MKReceiveLetterCell *cell2 = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MKReceiveLetterCell class]) forIndexPath:indexPath];
            
            return cell2;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIView *letterView = [self animateViewAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(letterViewSelectedIndexPath:cell:animateView:)]) {
        [self.delegate letterViewSelectedIndexPath:indexPath cell:cell animateView:letterView];
    }
}

// 根据不同的indexPath返回对应的letterView
- (UIView *)animateViewAtIndexPath:(NSIndexPath *)indexPath {
    UIView *animateView;
    if (indexPath.row%2 == 0) {
        MKSentLetterCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        animateView = cell.sentBackView;
    } else {
        MKReceiveLetterCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        animateView = cell.receiveBackView;
    }
    return animateView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
