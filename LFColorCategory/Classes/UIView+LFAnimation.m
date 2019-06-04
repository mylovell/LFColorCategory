//
//  UIView+LFAnimation.m
//  LFAnimation
//
//  Created by Feng Luo on 2019/3/1.
//  Copyright © 2019年 Feng Luo. All rights reserved.
//

#import "UIView+LFAnimation.h"
#import <objc/runtime.h>
//#import "UIView+getCurrentVC.h"
//#import "ViewController.h"

@interface UIView ()
// <CAAnimationDelegate>

/// 创建时候的speed
@property (nonatomic, assign) float originSpeed;

@end

@implementation UIView (LFAnimation)

- (CABasicAnimation *)addAnimationForRotation {
    return [self addAnimationForRotationWithSpeed:1.0];
}
- (CABasicAnimation *)addAnimationForRotationWithSpeed:(float)speed {
    self.originSpeed = speed;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.speed = speed;
//    anim.delegate = self;
    //设置动画的属性值
    anim.keyPath = @"transform.rotation";// @"transform.rotation"
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2);
    
    anim.repeatCount = MAXFLOAT;// MAXFLOAT
    anim.duration = 2;// 3
    
    // 动画结束后是否要保留最后的动画状态
    anim.removedOnCompletion = NO;
    
    anim.fillMode = kCAFillModeForwards;
    
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // YES:每一次从fromValue到toValue后，就会从toValue到fromValue在动画一次，往返各一次。
    anim.autoreverses = NO;
    [self.layer addAnimation:anim forKey:@"LFAnimation"];
    
    return anim;
}

- (void)addAnimationForRotationM_PI {
    
    // view旋转
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.affineTransform = CGAffineTransformRotate(self.layer.presentationLayer.affineTransform, M_PI);
    }];
    
}


- (void)addAnimationForPosition:(NSString *)keyPath {
    [self addAnimationForPosition:keyPath speed:1.0];
}
- (void)addAnimationForPosition:(NSString *)keyPath speed:(float)speed {
    self.originSpeed = speed;

    CABasicAnimation *ani = [CABasicAnimation animation];
    ani.speed = speed;
    ani.keyPath = keyPath;//比如 @"position.x"
    ani.fromValue = 0;
    ani.toValue = @(200);
    
    // 动画完成后，layer上的动画是否删除
    ani.removedOnCompletion = NO;

    // 想要fillMode有效，最好removedOnCompletion = NO
    /*
     自实验：
     kCAFillModeForwards:@"forwards"    // 样子是最后的，实际位置是之前的
     kCAFillModeBackwards:@"backwards"  // 样子是之前的，实际位置是之前的
     kCAFillModeBoth:@"both"            // 样子是最后的，实际位置是之前的
     kCAFillModeRemoved:@"removed"      // 样子是之前的，实际位置是之前的

     参考：
     kCAFillModeRemoved 这个是默认值，也就是说当动画开始前和动画结束后，动画对layer都没有影响，动画结束后，layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后，layer会一直保持着动画最后的状态
     kCAFillModeBackwards 在动画开始前，只需要将动画加入了一个layer，layer便立即进入动画的初始状态并等待动画开始。
     kCAFillModeBoth 这个其实就是上面两个的合成.动画加入后开始之前，layer便处于动画初始状态，动画结束后layer保持动画最后的状态
     */
    ani.fillMode = kCAFillModeRemoved;

    [self.layer addAnimation:ani forKey:@"LFAnimation"];

}

- (void)addAnimationForScale {
    
}
- (void)addAnimationForScale:(NSString *)keyPath speed:(float)speed {
    self.originSpeed = speed;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.speed = speed;
    //设置动画的属性值
    anim.keyPath = @"transform.scale";// @"transform.scale"
    anim.toValue = @(M_PI * 2);
    
    anim.repeatCount = MAXFLOAT;// MAXFLOAT
    anim.duration = 3;
    
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:anim forKey:@"LFAnimation"];
    
}


/// 移除并停止（动画将无法恢复）
- (void)stopAnimation {
    [self.layer removeAnimationForKey:@"LFAnimation"];
}

/// 暂停
- (void)pauseAnimation {
    
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 让CALayer的时间停止走动
    self.layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    self.layer.timeOffset = pausedTime;
}
/// 恢复
- (void)resumeAnimation {
    CFTimeInterval pausedTime = self.layer.timeOffset;
    
    // 2. 取消上次记录的停留时刻
    self.layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    self.layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 1. 让CALayer的时间继续行走（speed在这个位置赋值除1.0外的数字才有效）
    self.layer.speed = self.originSpeed;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    self.layer.beginTime = timeSincePause;
}

//#pragma mark - CAAnimationDelegate
///* Called when the animation begins its active duration. */
//- (void)animationDidStart:(CAAnimation *)anim {
//    NSLog(@"catorgory%s",__func__);
//
//}
//
///* Called when the animation either completes its active duration or
// * is removed from the object it is attached to (i.e. the layer). 'flag'
// * is true if the animation reached the end of its active duration
// * without being removed.
//
// * 暂停不会调用
// */
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSLog(@"catorgory%s---%i",__func__,flag);
//
//}

#pragma mark - runtime property
-(void)setOriginSpeed:(float)originSpeed {
    objc_setAssociatedObject(self, @"originSpeedKey", @(originSpeed), OBJC_ASSOCIATION_ASSIGN);
}

-(float)originSpeed {
    return [objc_getAssociatedObject(self, @"originSpeedKey") floatValue];
}

- (void)fastColor {
    self.backgroundColor = [UIColor blueColor];
}

@end
