//
//  GameScene.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "GameScene.h"

/// 速度比例，用于是适配各屏幕设备上的小球速度
#define SPEEDROTATE 4.0 / 760.0

@interface GameScene ()

/// 最近小球出现的时间
@property NSTimeInterval lastBallInterval;
/// 上次更新时间
@property NSTimeInterval lastUpdateInterval;
/// 最近道具小球出现的时间
@property NSTimeInterval lastItemsInterval;
/// 道具小球随即出现时间
@property u_int32_t ItemsAppearRandomTime;
/// 道具小球出现时间段
@property int ItemsAppearTimePart;
/// 当前游戏时间
@property int nowTime;
/// 最佳游戏时间
@property int bestTime;

/// 文件管理器
@property FileManager* fileManager;

@end

@implementation GameScene

#pragma mark - 初始化方法

-(instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        [self initProperty];
        
        // 游戏场景设置
        self.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:216.0/255.0 blue:238.0/255.0 alpha:1];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];   // 设置静态物理实体
        self.physicsBody.friction = 0;   // 取消摩擦
        self.physicsWorld.gravity = CGVectorMake(0, -1);   // 取消重力
        self.physicsBody.angularDamping = 0;  // 取消空气阻力
        self.physicsWorld.contactDelegate = self;
        
        // 添加水底
        CGRect waterRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode* water = [[SKNode alloc]init];
        water.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:waterRect];
        [self addChild:water];
        water.physicsBody.categoryBitMask = waterCategory;
    }
    return self;
}

#pragma mark - 游戏配置方法

/// 游戏启动
-(void)startGame {
    self.gameStart = YES;
    NSLog(@"开始游戏");
    // 初始化标签，读取文件数据
    [self initLabel];
    [self.fileManager loadFile];
    // 根据读取到的游戏模式启动游戏
    switch (self.gamemode) {
        case Classic:
            [self startGameModeClassic];
            break;
        case Normal:
            [self startGameModeNormal];
            break;
        case Items:
            [self startGameModeItems];
            break;
        default:
            break;
    }
}

/// 启动经典模式
-(void)startGameModeClassic {
    NSLog(@"开始经典游戏模式");
    
    // 设置游戏模式和标签
    self.bestTime = [self.fileManager.bestTimeClassic intValue];
    self.lbl_bestTime.text = [NSString stringWithFormat:@"Classic Best:%@", [self timeTransformWithTime:self.bestTime]];
    self.gamemode = Classic;
    
    [self addBar];
    [self addClassicBall];
}

/// 启动普通模式
-(void)startGameModeNormal {
    NSLog(@"开始普通游戏模式");
    
    self.bestTime = [self.fileManager.bestTimeNormal intValue];
    self.lbl_bestTime.text = [NSString stringWithFormat:@"Normal Best:%@", [self timeTransformWithTime:self.bestTime]];
    self.gamemode = Normal;
    
    [self addBar];
    [self addClassicBall];
}

/// 启动道具模式
-(void)startGameModeItems {
    NSLog(@"开始道具游戏模式");
    
    self.bestTime = [self.fileManager.bestTimeIdems intValue];
    self.lbl_bestTime.text = [NSString stringWithFormat:@"Items Best:%@", [self timeTransformWithTime:self.bestTime]];
    self.gamemode = Items;
    
    [self addBar];
    [self addClassicBall];
}

/// 添加经典小球
-(void)addClassicBall {
    int initX = self.frame.size.width - 20;
    CGFloat initSpeed = 4;
    Ball* ball = [[Ball alloc]initWithCenter:CGPointMake(arc4random()%initX+10, self.frame.size.height) WithSpeed:initSpeed];
    [self addChild:ball];
    [ball setPhysicsBody];
}

/// 添加道具小球
-(void)addItemsBall {
    int random = arc4random()%3;
    int initX = self.frame.size.width - 20;
    CGFloat initSpeed = SPEEDROTATE * self.frame.size.height * 2;
    Ball* ball;
    switch (random) {
        case 0:
            ball = [[AllCleanBall alloc]initWithCenter:CGPointMake(arc4random()%initX+10, self.frame.size.height) AndSpeed:initSpeed];
            break;
        case 1:
            ball = [[LongBarBall alloc]initWithCenter:CGPointMake(arc4random()%initX+10, self.frame.size.height) AndSpeed:initSpeed];
            break;
        case 2:
            ball = [[SlowBall alloc]initWithCenter:CGPointMake(arc4random()%initX+10, self.frame.size.height) AndSpeed:initSpeed];
            break;
        default:
            break;
    }
    [self addChild:ball];
    [ball setPhysicsBody];
}

/// 添加Bar
-(void)addBar {
    self.bar = [[Bar alloc]initWithImageName:@"BarImage"];
    self.bar.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addChild:self.bar];
    [self.bar setPhysicBody];
}

/// 游戏结束
-(void)gameOver {
    if (self.gameStart) {
        self.gameStart = NO;
        [self checkTheTime];
        self.lbl_bestTime.text = [NSString stringWithFormat:@"Best:%@", [self timeTransformWithTime:self.bestTime]];
        [self.gameViewController.waterWaveView waterRiseUp];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        for (Ball* child in self.children) {
            if (child) {
                child.physicsBody.velocity = CGVectorMake(0, 0);
            }
        }
    }
}

#pragma mark - 碰撞处理

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody* firstBody = [[SKPhysicsBody alloc]init];
    SKPhysicsBody* secondBody = [[SKPhysicsBody alloc]init];
    // 始终把类别码小的物体赋给 firstBody，快速排序
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 处理球和水底的碰撞
    if ((firstBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == cleanBallCategory || firstBody.categoryBitMask == longBallCategory || firstBody.categoryBitMask == slowBallCategory) && secondBody.categoryBitMask == waterCategory && self.gameStart == YES) {
        [self gameOver];
        [firstBody.node removeFromParent];
    }
    // 处理小球和小球之间的碰撞
    else if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == ballCategory && self.gameStart == YES) {
        Ball* firstBall = (Ball*)firstBody.node;
        Ball* secondBall = (Ball*)secondBody.node;
        if (self.gamemode == Normal || self.gamemode == Items) {
            firstBall.knockTimes++;
            secondBall.knockTimes++;
            if (firstBall.knockTimes > 3) {
                [firstBall removeFromParent];
            }
            if (secondBall.knockTimes > 3) {
                [secondBall removeFromParent];
            }
        }
        [firstBall knockBall];
        [secondBall knockBall];
    }
    // 碰撞消失小球
    else if (firstBody.categoryBitMask == cleanBallCategory && secondBody.categoryBitMask == ballCategory && self.gameStart == YES) {
        AllCleanBall* cleanball = (AllCleanBall*)firstBody.node;
        Ball* ball = (Ball*)secondBody.node;
        if (cleanball.cleanSkill) {
            [secondBody.node removeFromParent];
        }
        [ball knockBall];
    }
    else if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == cleanBallCategory && self.gameStart == YES) {
        AllCleanBall* cleanball = (AllCleanBall*)secondBody.node;
        Ball* ball = (Ball*)firstBody.node;
        if (cleanball.cleanSkill) {
            [firstBody.node removeFromParent];
        }
        [ball knockBall];
    }
    // 处理小球碰撞效果
    else if (firstBody.categoryBitMask == ballCategory && self.gameStart == YES) {
        Ball* ball = (Ball*)firstBody.node;
        [ball knockBall];
    }
    else if (secondBody.categoryBitMask == ballCategory && self.gameStart == YES) {
        Ball* ball = (Ball*)secondBody.node;
        [ball knockBall];
    }
    // 道具小球处理
    else if (firstBody.categoryBitMask == cleanBallCategory && secondBody.categoryBitMask == barCategory && self.gameStart == YES) {
        AllCleanBall* cleanball = (AllCleanBall*)firstBody.node;
        if (!cleanball.cleanSkill) {
            cleanball.cleanSkill = YES;
        }
    }
    else if (firstBody.categoryBitMask == longBallCategory && secondBody.categoryBitMask == barCategory && self.gameStart == YES) {
        [self.bar barBecomeLong];
        [firstBody.node removeFromParent];
    }
    else if (firstBody.categoryBitMask == slowBallCategory && secondBody.categoryBitMask == barCategory && self.gameStart == YES) {
        NSArray* children = self.children;
        for (Ball* ball in children) {
            if (ball) {
                ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx / 4, 0);
            }
        }
        [firstBody.node removeFromParent];
    }
}

#pragma mark - 时间处理

-(void)update:(CFTimeInterval)currentTime {
    if (self.gameStart == YES) {
        CFTimeInterval timeSinceLast = currentTime - self.lastUpdateInterval;
        self.lastUpdateInterval = currentTime;
        if (timeSinceLast > 1) {
            timeSinceLast = 1/60;
            self.lastUpdateInterval = currentTime;
        }
        self.nowTime++;
        [self changeTheLabelWithTime:self.nowTime];
        [self updatetimeSinceLastUpdate:timeSinceLast];
        
        // 限制小球速度
        Ball* ball = (Ball*)[self childNodeWithName:@"ball"];
        if (ball) {
            [ball setTheBall];
            CGFloat speed = sqrt(ball.physicsBody.velocity.dx * ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy);
            if (speed > 600) {
                NSLog(@"speed limit mode begin");
                ball.physicsBody.linearDamping = 0.4;
            }else {
                ball.physicsBody.linearDamping = 0;
            }
        }
    }
}

/// 小球出现时间
-(void)updatetimeSinceLastUpdate:(CFTimeInterval)time {
    if (self.gamemode == Items) {
        self.lastItemsInterval += time;
        if (self.lastItemsInterval > self.ItemsAppearRandomTime + self.ItemsAppearTimePart) {
            self.lastItemsInterval = 0;
            self.ItemsAppearTimePart = 9;
            [self addItemsBall];
        }
        [self.bar barBackShort];
    }
    self.lastBallInterval += time;
    if (self.lastBallInterval > 2.5) {
        self.lastBallInterval = 0;
        [self addClassicBall];
    }
}

#pragma mark - 私有方法

/// 当前时间标签变化动画
-(void)changeTheLabelWithTime:(int)time {
    if (self.nowTime > self.bestTime) {
        self.lbl_bestTime.hidden = YES;
        [self.lbl_currentTime runAction:[SKAction scaleTo:2 duration:1]];
    }
    self.lbl_currentTime.text = [self timeTransformWithTime:time];
}

/// 比较当前时间和最高时间并存档
-(void)checkTheTime {
    if (self.nowTime > self.bestTime) {
        self.bestTime = self.nowTime;
        self.gameViewController.best = YES;
        [self.fileManager writeFileOfMode:self.gamemode WithTime:[[NSNumber alloc]initWithInt:self.bestTime]];
    }
}

/// 将时间（毫秒）转换为00:00格式
-(NSString*)timeTransformWithTime:(int)time {
    NSString* str = @"";
    int second = time / 60;
    int midSecond = time % 60;
    if (second < 10) {
        str = [NSString stringWithFormat:@"0%d\"", second];
    } else {
        str = [NSString stringWithFormat:@"%d\"", second];
    }
    if (midSecond < 10) {
        str = [str stringByAppendingFormat:@"0%d", midSecond];
    } else {
        str = [str stringByAppendingFormat:@"%d", midSecond];
    }
    return str;
}

/// 配置文字
-(void)initLabel {
    self.lbl_currentTime = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Thin"];
    self.lbl_currentTime.hidden = NO;
    self.lbl_currentTime.fontSize = self.saveCurrentTime.font.pointSize;
    self.lbl_currentTime.position = CGPointMake(self.saveCurrentTime.center.x, self.frame.size.height - self.saveCurrentTime.center.y);
    self.lbl_currentTime.text = @"00\"00";
    
    self.lbl_bestTime = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Thin"];
    self.lbl_bestTime.hidden = NO;
    self.lbl_bestTime.fontSize = self.saveBestTime.font.pointSize;
    self.lbl_bestTime.position = CGPointMake(self.saveBestTime.center.x, self.frame.size.height - self.saveBestTime.center.y);
    self.lbl_bestTime.text = @"Best:00\"00";
    
    [self addChild:self.lbl_currentTime];
    [self addChild:self.lbl_bestTime];
}

/// 配置初始属性
-(void)initProperty {
    self.waveHeight = 0;
    self.lastBallInterval = 0;
    self.lastUpdateInterval = 0;
    self.lastItemsInterval = 0;
    self.ItemsAppearRandomTime = arc4random()%9;
    self.ItemsAppearTimePart = 0;
    self.nowTime = 0;
    self.bestTime = 0;
    self.fileManager = [[FileManager alloc]init];
    self.gameViewController = [[GameViewController alloc]init];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // 获取触摸位置
        CGPoint location = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        
        // 获取Bar结点
        SKSpriteNode* barNode = (SKSpriteNode*)[self childNodeWithName:@"bar"];
        // 计算Bar将要移动的位置
        if (barNode && self.gameStart == YES) {
            CGFloat barNodeX = barNode.position.x + (location.x - previousLocation.x);
            CGFloat barNodeY = barNode.position.y + (location.y - previousLocation.y);
            
            // 限制Bar的移动距离
            barNodeX = fmax(barNodeX, self.bar.self.size.width / 2);
            barNodeX = fmin(barNodeX, self.size.width - self.bar.size.width / 2);
            barNodeY = fmin(barNodeY, self.size.height - self.bar.size.height * 2);
            barNodeY = fmax(barNodeY, self.waveHeight);
            self.bar.position = CGPointMake(barNodeX, barNodeY);
            
        }
    }
}

@end
