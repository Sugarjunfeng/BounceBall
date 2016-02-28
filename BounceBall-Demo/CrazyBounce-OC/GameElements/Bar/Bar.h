//
//  Bar.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bar : SKSpriteNode

- (instancetype)initWithImageName:(NSString*)imageName;

-(void) setPhysicBody;
-(void) barBecomeLong;
-(void) barBackShort;

@end
