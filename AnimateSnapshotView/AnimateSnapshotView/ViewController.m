//
//  ViewController.m
//  AnimateSnapshotView
//
//  Created by mokong on 16/1/27.
//  Copyright © 2016年 mokong. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "LetterView.h"
#import "MKCustomReadLetterView.h"


typedef void (^AnimateFinished)(void); // 动画结束的回调

@interface ViewController ()<LetterViewDelegate, MKCustomReadLetterViewDelegate>

@property (nonatomic, strong) LetterView *letterView; // 列表界面
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MKCustomReadLetterView *readLetterView; // 读信
@property (nonatomic, strong) UIView *animateView; // 点击的信封
@property (nonatomic, assign) CGPoint animateViewCenter; // 直接显示不正确，需要转换坐标系

@property (nonatomic, strong) UIView *alphaView; // 半透明背景

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupSubviews];
    self.dataArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
}

- (void)setupSubviews {
    // 信封列表界面
    [self setupLetterView];
    // 读信界面
    [self setupReadLetterView];
    // 半透明背景
    [self setupAlphaView];
}

- (void)setupLetterView {
    if (self.letterView) {
        return;
    }
    
    self.letterView = [[LetterView alloc] initWithFrame:self.view.bounds];
    self.letterView.delegate = self;
    [self.view addSubview:self.letterView];
}

- (void)setupAlphaView {
    if (self.alphaView) {
        return;
    }
    
    self.alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.alphaView.backgroundColor = [UIColor blackColor];
    self.alphaView.alpha = 0.72;
    [self.view addSubview:self.alphaView];
    self.alphaView.hidden = YES;
}

- (void)setupReadLetterView {
    if (self.readLetterView) {
        return;
    }
    self.readLetterView = [[MKCustomReadLetterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.readLetterView.delegate = self;
    [self.navigationController.view.window addSubview:self.readLetterView];
    self.readLetterView.hidden = YES;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self setupSubviews];
    self.letterView.dataArray = _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - letter view delegate
- (void)letterViewSelectedIndexPath:(NSIndexPath *)indexPath
                               cell:(UITableViewCell *)cell
                        animateView:(UIView *)animateView
{
    self.animateView = animateView;
    
    // 转换坐标系
    CGPoint animateViewCenter = [cell convertPoint:animateView.center toView:self.view];
    self.animateViewCenter = animateViewCenter;
    
    [self showView:self.readLetterView
          withView:self.animateView
          finished:^{
              NSLog(@"查看详情完成");
          }];
}

#pragma mark - read letter view delegate
- (void)clickReadLetterView {
    // "关闭readLetterView"
    [self animateView:self.readLetterView
               toView:self.animateView
             finished:^{
                 // do something else
                 NSLog(@"关闭详情完成");
             }];
}


#pragma mark - animate

/**
 *  @brief 返回对应view的snapshot
 *
 *  @param inputView 输入的view
 *
 *  @return 返回的snapshot
 */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

/**
 *  动画 查看详情
 *
 *  @param viewToshow      要展示的view
 *  @param currentView     起始的view
 *  @param animateFinished 动画结束的回调
 */
- (void)showView:(UIView *)viewToshow
        withView:(UIView *)currentView
        finished:(AnimateFinished)animateFinished
{
    // Taking a snapshot of the selected row using helper method
    UIView *snapShot = [self customSnapshotFromView:currentView];
    
    // Add the snapshot as a subview, centered cell's center
    CGPoint viewCenter = self.view.window.center;
    
    CGPoint cellCenter = _animateViewCenter;
    snapShot.center = cellCenter;
    snapShot.alpha = 0.0;
    snapShot.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:snapShot];
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.transform = CGAffineTransformMakeScale(1.05, 1.05);
        snapShot.alpha = 0.98;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            snapShot.center = viewCenter;
            snapShot.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.alphaView.hidden = NO;
            viewToshow.hidden = NO;
            [snapShot removeFromSuperview];
            animateFinished();
        }];
    }];
}

/**
 *  @brief 动画 关闭详情
 *
 *  @param sourceView       起始位置的view
 *  @param destinationView  要展示的view
 *  @param animatedFinished 动画成功的回调
 */
- (void)animateView:(UIView *)sourceView
             toView:(UIView *)destinationView
           finished:(AnimateFinished)animatedFinished
{
    /**
     *  逻辑：1. 得到两个view的snapshot, sourcesnapshot/destinationsnapshot
     *       2. 然后，设置destinationsnapshot的中心为整个view的中心，设置为透明（即不显示）
     *       3. 隐藏当前sourceView，第一个动画实现，sourceViewsnapshot大小变为destinationsnapshot的大小，然后隐藏，同时显示destinationsnapshot
     *       4. 第二个动画实现：destinationsnapshot移动回对应位置，然后隐藏
     */
    
    // 1
    UIView *sourceSnapshot = [self customSnapshotFromView:sourceView];
    UIView *destinationSnapshot = [self customSnapshotFromView:destinationView];
    
    // 2
    CGPoint viewCenter = self.view.center;
    CGPoint destinationCenter = _animateViewCenter;
    destinationSnapshot.center = viewCenter;
    destinationSnapshot.alpha = 1.0;
    [self.view addSubview:sourceSnapshot];
    [self.view addSubview:destinationSnapshot];
    
    // 3
    sourceView.hidden = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         sourceSnapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         sourceSnapshot.alpha = 0.98;
                         sourceSnapshot.frame = destinationSnapshot.frame;
                     } completion:^(BOOL finished) {
                         
                         self.alphaView.hidden = YES;
                         destinationSnapshot.alpha = 0.98;
                         [sourceSnapshot removeFromSuperview];
                         
                         // 4
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              destinationSnapshot.center = destinationCenter;
                                              destinationSnapshot.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished) {
                                              [destinationSnapshot removeFromSuperview];
                                              animatedFinished();
                                          }];
                     }];
    
}



@end
