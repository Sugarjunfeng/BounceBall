//
//  AllCleanBall.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-05.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "Ball.h"

@interface AllCleanBall : Ball

@property BOOL cleanSkill;

- (instancetype)initWithCenter: (CGPoint)center AndSpeed:(CGFloat)speed;

-(void) setPhysicsBody;
- (void)setTheBall;
-(void) knockBall;

@end
