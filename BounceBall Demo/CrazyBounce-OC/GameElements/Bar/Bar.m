//
//  Bar.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "Bar.h"
#import "GameScene.h"

@interface Bar ()

@property UIImage* barImage;
@property BOOL isLong;
@property int times;

@end

@implementation Bar

#pragma mark - 初始化方法

- (instancetype)initWithImageName:(NSString*)imageName
{
    self.barImage = [UIImage imageNamed:@"BarImage"];
    self = [super initWithTexture:[SKTexture textureWithImageNamed:imageName] color:[SKColor clearColor] size:self.barImage.size];
    self.name = @"bar";
    return self;
}

#pragma mark - SpriteKit精灵设置

-(void) setPhysicBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.barImage.size];

    // 将球拍设置为静态物体
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = barCategory;
    self.physicsBody.collisionBitMask = 0;   //不会对其他碰撞物体发生作用力
}

#pragma mark - 技能设置

-(void) barBecomeLong {
    [self runAction:[SKAction scaleXTo:2 duration:1]];
    self.isLong = YES;
}

-(void) barBackShort {
    if (self.isLong) {
        self.times++;
        if (self.times > 600) {
            [self runAction:[SKAction scaleXTo:1 duration:1]];
            self.isLong = NO;
            self.times = 0;
        }
    }
}

@end
