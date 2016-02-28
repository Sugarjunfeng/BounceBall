//
//  GameElements.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-05.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#ifndef CrazyBounce_OC_GameElements_h
#define CrazyBounce_OC_GameElements_h

static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t cleanBallCategory = 0x1 << 1;
static const uint32_t longBallCategory = 0x1 << 2;
static const uint32_t slowBallCategory = 0x1 << 3;
static const uint32_t waterCategory = 0x1 << 4;
static const uint32_t barCategory = 0x1 << 5;

/// 游戏模式
typedef enum : NSUInteger {
    /// 普通模式
    Normal,
    /// 经典模式
    Classic,
    /// 道具模式
    Items,
}gameMode;

@protocol viewPassValueDelegate

@optional
-(void)passValueWithCurrentTime:(NSString*)currentTime BestTime:(NSString*)bestTime GameMode:(NSString*)gamemode Best:(BOOL)best;

@end

#endif
