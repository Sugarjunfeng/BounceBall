//
//  Ball.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameElements.h"

@interface Ball: SKSpriteNode {
    int testDown;
}

/// 初始速度
@property CGFloat initSpeed;

/// 小球碰撞次数
@property int knockTimes;

- (instancetype)initWithCenter:(CGPoint) center WithSpeed:(CGFloat)speed;
- (instancetype)initWithCenter:(CGPoint) center WithSize:(CGSize)size AndSpeed:(CGFloat)speed;
-(void) setPhysicsBody;
- (void)setTheBall;
-(void) knockBall;
@end
