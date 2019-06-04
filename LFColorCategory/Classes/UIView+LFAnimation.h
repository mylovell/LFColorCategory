//
//  UIView+LFAnimation.h
//  LFAnimation
//
//  Created by Feng Luo on 2019/3/1.
//  Copyright © 2019年 Feng Luo. All rights reserved.
//
//  1、layer动画
//  2、只支持一个layer只添加一种CAAnimation动画，再次添加会覆盖之前的

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LFAnimation)

/// 添加即开始
- (CABasicAnimation *)addAnimationForRotation;
- (CABasicAnimation *)addAnimationForRotationWithSpeed:(float)speed;
- (void)addAnimationForPosition:(NSString *)keyPath;//如position.x
- (void)addAnimationForPosition:(NSString *)keyPath speed:(float)speed;
- (void)addAnimationForScale;
- (void)addAnimationForScale:(NSString *)keyPath speed:(float)speed;

- (void)addAnimationForRotationM_PI;//view动画，原有基础上旋转180
/// 通用动画
//- (void)addAnimation:(NSString *)keyPath speed:(float)speed fromValue:(id)value toValue:(id)value;

/// 移除并停止（动画将无法恢复）
- (void)stopAnimation;


/// 暂停
- (void)pauseAnimation;
/// 恢复
- (void)resumeAnimation;

- (void)fastColor;

@end

NS_ASSUME_NONNULL_END
