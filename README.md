# AnimateSnapShotView
complete animate with snapshot 
动画：
复杂动画的实现：首先要拆分，明确你自己要实现的效果是什么，然后开始拆分，第一步实现什么，然后实现什么...，怎么样链接起来。把复杂的动画拆分成一个个小步骤，然后一步步实现就可以了。

![gif1](http://upload-images.jianshu.io/upload_images/1208479-91edb45fa874da7c.gif?imageMogr2/auto-orient/strip)

> snapshotViewAfterScreenUpdates(_:) 这个方法我在做拖拽tableView的item的时候(eg: [SystemPreference](https://github.com/mokong/systemPreference))看到的，感觉用来做动画很好用。相当于截个图，然后拿着这个截图，实现各种动画效果。
eg:
1.  如果你是一个电商项目，将商品加入购物车，这个动画就可以用这个来实现（Ps：我记得京东还是淘宝久有这个效果，但是我却又找不到了），点击加入购物车，然后对商品生成一个快照，然后缩小移动到购物车（还可以加入旋转的动画），到购物车的位置，移除。Perfect！
2. 我做的这个项目，读信的过程就是用这个效果实现，点击信封，然后生成快照，然后快照位移到屏幕中间，消失，然后信封详情出现。


![image1](http://upload-images.jianshu.io/upload_images/1208479-c4bfbecedfbd18a9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 实现
> 首先，定义动画效果的实现：
1. 查看信件：a. 点击信件，然后生成信件快照; b.信件快照位移到屏幕中央；同时信件详情出现，信件快照消失；
2. 关闭详情：a. 点击空白处，生成信件详情快照和信件快照；信件快照起始状态隐藏；b.信件详情快照慢慢变小到和信件快照同样大小；然后消失，信件快照显示；c:信件快照位移到信件的位置，然后消失；

## 代码
```Objective-C
/**
 *  @brief 返回对应view的snapshot
 *
 *  @param inputView 输入的view
 *
 *  @return 返回的snapshot
 */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}```

> 关闭详情

```Objective-C

/**
 *  动画 关闭详情
 *
 *  @param sourceView      起始位置的view
 *  @param destinationView 终点位置的view
 *  @param animateFinished 动画结束的回调
 */
- (void)animateView:(UIView *)sourceView
             toView:(UIView *)destinationView
           finished:(AnimateFinished)animatedFinished
{
    /**
     *  逻辑：1. 得到两个view的snapshot, sourcesnapshot/destinationsnapshot
     *       2. 然后，设置destinationsnapshot的中心为整个view的中心，设置为透明（即不显示）
     *       3. 隐藏当前sourceView，第一个动画实现，sourceViewsnapshot大小变为destinationsnapshot的大小，然后隐藏，同时显示destinationsnapshot
     *       4. 第二个动画实现：destinationsnapshot移动回对应位置，然后隐藏
     */
    
    // 1
    UIView *sourceSnapshot = [self customSnapshotFromView:sourceView];
    UIView *destinationSnapshot = [self customSnapshotFromView:destinationView];
    
    // 2
    CGPoint viewCenter = self.view.center;
    CGPoint destinationCenter = destinationView.center;
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
    
}```

> 查看详情

```Objective-C

/**
 *  动画 查看详情
 *
 *  @param viewToshow      要展示的view
 *  @param currentView     起始的view
 *  @param animateFinished 动画结束的回调
 */
- (void)showView:(UIView *)viewToshow
        withView:(UIView *)currentView
        finished:(Finished)animateFinished
{
    // Taking a snapshot of the selected row using helper method
    UIView *snapShot = [self customSnapshotFromView:currentView];
    
    // Add the snapshot as a subview, centered cell's center
    CGPoint viewCenter = self.view.window.center;
    CGPoint cellCenter = currentView.center;
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
}```

> Ps: 也许会好奇，为什么查看和关闭会是两个不同的部分？可以再回头查看一下分割的动画，发现过程其实是不一样的，查看详情比关闭少了一个步骤。
代码：暂时没有