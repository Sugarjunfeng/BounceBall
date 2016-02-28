//
//  GameScene.h
//  CrazyBounce-OC
//

//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import "Bar.h"
#import "Ball.h"
#import "AllCleanBall.h"
#import "LongBarBall.h"
#import "SlowBall.h"
#import "FileManager.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>

/// 主游戏管理类
@property GameViewController* gameViewController;
/// 保存当前时间
@property UILabel* saveCurrentTime;
/// 保存最高时间
@property UILabel* saveBestTime;
/// 当前游戏模式
@property gameMode gamemode;
/// 波浪高度
@property CGFloat waveHeight;
/// 当前游戏时间标签
@property SKLabelNode* lbl_currentTime;
/// 最高游戏时间标签
@property SKLabelNode* lbl_bestTime;
/// 检测游戏是否开始
@property BOOL gameStart;
/// 滑块
@property Bar* bar;

-(void)startGame;

@end
