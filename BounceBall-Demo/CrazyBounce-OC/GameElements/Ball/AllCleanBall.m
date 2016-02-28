//
//  AllCleanBall.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-05.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "AllCleanBall.h"

@interface AllCleanBall ()

@property SKTexture* allCleanBall;

@property int cleanTime;

@end

@implementation AllCleanBall

- (instancetype)initWithCenter: (CGPoint)center AndSpeed:(CGFloat)speed
{
    CGSize size = [UIImage imageNamed:@"BallDestroyImage"].size;
    self = [super initWithCenter:center WithSize:size AndSpeed:speed];
    self.allCleanBall = [SKTexture textureWithImageNamed:@"BallDestroyImage"];
    self.cleanSkill = NO;
    self.cleanTime = 0;
    return self;
}

-(void)setPhysicsBody {
    self.texture = self.allCleanBall;
    self.name = @"ball";
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 2];
    self.physicsBody.restitution = 1;   //弹性
    self.physicsBody.friction = 0;    // 摩擦力
    self.physicsBody.linearDamping = 0;   //线性阻尼，气体或液体对物体的减速效果
    // 添加推力
    [self.physicsBody applyImpulse:CGVectorMake(arc4random()%6 + 1, self.initSpeed)];
    self.physicsBody.usesPreciseCollisionDetection = YES;  // 精确碰撞检测
    self.physicsBody.categoryBitMask = cleanBallCategory;
    self.physicsBody.contactTestBitMask = waterCategory | ballCategory | barCategory;
}

-(void)setTheBall {
    if (self.cleanSkill) {
        self.cleanTime++;
    }
    if (self.cleanTime > 60) {
        self.cleanTime = 0;
        self.cleanSkill = NO;
        [self removeFromParent];
    }
}

-(void)knockBall {
    
}

@end
