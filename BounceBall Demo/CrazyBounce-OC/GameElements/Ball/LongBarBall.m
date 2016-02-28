//
//  LongBarBall.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-05.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "LongBarBall.h"

@interface LongBarBall ()

@property SKTexture* longBarBall;

@end

@implementation LongBarBall

- (instancetype)initWithCenter:(CGPoint)center AndSpeed:(CGFloat)speed
{
    CGSize size = [UIImage imageNamed:@"BallLongImage"].size;
    self = [super initWithCenter:center WithSize:size AndSpeed:speed];
    self.longBarBall = [SKTexture textureWithImageNamed:@"BallLongImage"];
    return self;
}

-(void)setPhysicsBody {
    self.texture = self.longBarBall;
    self.name = @"ball";
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 2];
    self.physicsBody.restitution = 1;   //弹性
    self.physicsBody.friction = 0;    // 摩擦力
    self.physicsBody.linearDamping = 0;   //线性阻尼，气体或液体对物体的减速效果
    // 添加推力
    [self.physicsBody applyImpulse:CGVectorMake(arc4random()%6 + 1, self.initSpeed)];
    self.physicsBody.usesPreciseCollisionDetection = YES;  // 精确碰撞检测
    self.physicsBody.categoryBitMask = longBallCategory;
    self.physicsBody.contactTestBitMask = waterCategory | ballCategory | barCategory;
}

-(void)setTheBall {

}

-(void)knockBall {
    
}

@end
