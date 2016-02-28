//
//  waterView.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol waterViewDelegate

@optional
-(void) checkWaterRiseOver:(BOOL)riseOver;
-(void) checkWaterDropOver:(BOOL)dropOver;

@end

@interface waterView : UIView <waterViewDelegate>

/// waterViewDelegate代理
@property id<waterViewDelegate> delegate;

#pragma mark - 方法
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color waveHeight:(float)waveHeight;
-(void) changeWave:(float)waveHeight waveSpeed:(float)waveSpeed;
-(void) waterRiseUp;
-(void) waterDropDown;

@end
