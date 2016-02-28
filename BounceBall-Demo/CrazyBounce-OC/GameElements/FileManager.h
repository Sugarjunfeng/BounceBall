//
//  FileManager.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@interface FileManager : NSObject

#pragma mark - 属性

/// 读取的经典模式最高游戏时间
@property NSNumber* bestTimeClassic;
/// 读取的普通模式最高游戏时间
@property NSNumber* bestTimeNormal;
/// 读取的道具模式最高游戏时间
@property NSNumber* bestTimeIdems;

- (instancetype)init;
-(void) loadFile;
-(void) writeFileOfMode:(gameMode)mode WithTime:(NSNumber*)time;

@end
