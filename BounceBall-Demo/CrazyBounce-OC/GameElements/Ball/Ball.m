//
//  Ball.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "Ball.h"

@interface Ball ()

@property SKTexture* ballDownImage;
@property SKTexture* ballUpImage;
@property SKTexture* ballBounceImage;

/// 小球碰撞之后的时间
@property int ballShockTime;
/// 小球是否处于“shocked”状态
@property BOOL shocked;

@end

@implementation Ball

- (instancetype)initWithCenter:(CGPoint) center WithSpeed:(CGFloat)speed
{
    CGSize size = [UIImage imageNamed:@"BallShockedImage"].size;
    self = [self initWithCenter:center WithSize:size AndSpeed:speed];
    return self;
}

- (void)initImage
{
    self.ballDownImage = [SKTexture textureWithImageNamed:@"BallShockedImage"];
    self.ballUpImage = [SKTexture textureWithImageNamed:@"BallRelievedImage"];
    self.ballBounceImage = [SKTexture textureWithImageNamed:@"BallFrustratedImage"];
}

- (instancetype)initWithCenter:(CGPoint) center WithSize:(CGSize)size AndSpeed:(CGFloat)speed
{
    [self initImage];
    self = [super initWithTexture:self.ballDownImage color:[UIColor clearColor] size:size];
    if (self) {
        self.position = center;
        self.initSpeed = speed;
    }
    return self;
}

- (void)setTheBall {
    // 小球受到过撞击
    if (self.shocked) {
        self.ballShockTime++;
    }
    // 小球进入Frustrated状态
    if (self.ballShockTime > 30) {
        self.ballShockTime = 0;
        self.shocked = NO;
        if (self.physicsBody.velocity.dy > 0) {
            self.texture = self.ballDownImage;
        } else {
            self.texture = self.ballUpImage;
        }
    }
    if (!self.shocked) {
        if (self.physicsBody.velocity.dy > 0) {
            self.texture = self.ballDownImage;
        } else {
            self.texture = self.ballUpImage;
        }
    }
}

-(void) knockBall {
    if (!self.shocked) {
        self.shocked = YES;
        self.texture = self.ballBounceImage;
    }
}

-(void) setPhysicsBody {
    self.name = @"ball";
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 2];
    self.physicsBody.restitution = 1;   //弹性
    self.physicsBody.friction = 0;    // 摩擦力
    self.physicsBody.linearDamping = 0;   //线性阻尼，气体或液体对物体的减速效果
    // 添加推力
    [self.physicsBody applyImpulse:CGVectorMake(arc4random()%6 + 1, self.initSpeed)];
    self.physicsBody.usesPreciseCollisionDetection = YES;  // 精确碰撞检测
    self.physicsBody.categoryBitMask = ballCategory;
    self.physicsBody.contactTestBitMask = waterCategory | ballCategory;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"当前小球的碰撞次数：%d，大小：%@，速度：%f，当前位置：%@", self.knockTimes, NSStringFromCGSize(self.size), self.speed, NSStringFromCGPoint(self.position)];
}

- (id)debugQuickLookObject
{
    // 首先初始化您期望展示该自定义类信息的返回类型
    UIImage* quickLookImage;
    
    // 对这个类型进行处理
    if (self.texture == self.ballBounceImage) {
        quickLookImage = [UIImage imageNamed:@"BallFrustratedImage"];
    } else if (self.texture == self.ballDownImage){
        quickLookImage = [UIImage imageNamed:@"BallShockedImage"];
    } else {
        quickLookImage = [UIImage imageNamed:@"BallRelievedImage"];
    }
    
    // 返回快速查看对象
    return [UIColor colorWithRed:166.0/255.0 green:216.0/255.0 blue:238.0/255.0 alpha:1];
}

@end
