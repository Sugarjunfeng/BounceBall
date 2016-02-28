//
//  waterView.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "waterView.h"

@interface waterView ()

#pragma mark - 属性

/// 控制水面是否上升, true 上升
@property BOOL waterRise;
/// 控制水面是否下降，false下降
@property BOOL waterDrop;
/// 判定波浪处于上升还是下降状态
@property BOOL waveUp;

/// 水面上升或下降的速度
@property CGFloat waterRiseOrDropSpeed;
/// 水面高度
@property CGFloat currentLinePointY;
/// 保存的当前波浪高度
@property CGFloat savedWaveHeight;

/// 波浪颜色
@property UIColor *currentWaterColor;

/// 波浪高度
@property float peakHeight;
/// 波浪速度
@property float waveSpeed;
/// 波浪高度，用其改变波浪高度
@property float peakHeightChange;
/// 波浪速度，用其改变波浪速度
@property float waveSpeedChange;
/// 保存的波浪高度
@property float savedPeakHeightChange;
/// 保存的波浪速度
@property float savedSpeedHeightChange;

/// 计时器，用来控制波浪的运行
@property NSTimer *waveTimer;

-(void)waveAnimation;

@end

@implementation waterView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color waveHeight:(float)waveHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initProperty];
        self.peakHeight = 1 + self.peakHeightChange;
        self.currentWaterColor = color;
        self.currentLinePointY = self.frame.size.height - waveHeight;
        self.savedWaveHeight = self.currentLinePointY;
        self.waterRiseOrDropSpeed = self.waterRiseOrDropSpeed * self.frame.size.height;
    }
    self.waveTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(waveAnimation) userInfo:nil repeats:YES];
    
    
    return self;
}


#pragma mark - UIView自身重绘
-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 绘制水波
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [self.currentWaterColor CGColor]);
    
    CGFloat lineY = self.currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, lineY);
    
    for (CGFloat lineX = 0; lineX <= self.frame.size.width; lineX++) {
        CGFloat p1 = self.peakHeight;
        CGFloat p21 = lineX / 180.0 * M_PI;
        CGFloat p22 = 4 * self.waveSpeed / M_PI;
        CGFloat p2 = sin(p21+p22);
        CGFloat p3 = 5;
        
        lineY = (p1 * p2 * p3) + self.currentLinePointY;
        CGPathAddLineToPoint(path, nil, lineX, lineY);
    }
    
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

#pragma mark - 公开方法

/// 波浪属性设置
-(void) changeWave:(float)waveHeight waveSpeed:(float)waveSpeed {
    self.peakHeightChange = waveHeight;
    self.waveSpeedChange = waveSpeed;
}

/// 波浪上升
-(void) waterRiseUp {
    self.waterRise = YES;
}

/// 波浪下降
-(void) waterDropDown {
    self.waterDrop = YES;
    self.currentLinePointY = 0;
    self.savedPeakHeightChange = self.peakHeightChange;
    self.savedSpeedHeightChange = self.waveSpeedChange;
}

#pragma mark - 私有方法

/// 初始化属性
-(void) initProperty {
    _waterRise = NO;
    _waterDrop = NO;
    _waveUp = NO;
    
    _waterRiseOrDropSpeed = 8.5 / 768.0;
    _savedWaveHeight = 0;
    
    _waveSpeed = 0;
    _peakHeightChange = 1.5;
    _waveSpeedChange = 0.1;
    _savedPeakHeightChange = 1.5;
    _savedSpeedHeightChange = 0.1;
    
    _waveTimer = [[NSTimer alloc]init];
}

/// 波浪动画
-(void)waveAnimation {
    if (self.waveUp) {
        self.peakHeight += 0.01;
    }else {
        self.peakHeight -= 0.01;
    }
    
    if (self.peakHeight <= 1) {
        self.waveUp = YES;
    }
    
    if (self.peakHeight >= self.peakHeightChange) {
        self.waveUp = NO;
    }
    
    self.waveSpeed += self.waveSpeedChange;
    
    [self setNeedsDisplay];
    
    if (self.waterRise) {
        self.currentLinePointY -= self.waterRiseOrDropSpeed;
        self.peakHeightChange = 0.5;
        self.waveSpeedChange = 0.3;
        if (self.currentLinePointY < 0) {
            self.waterRise = NO;
            [self.waveTimer invalidate];
            self.waveTimer = [[NSTimer alloc]init];
            [self.delegate checkWaterRiseOver:YES];
        }
    }
    
    if (self.waterDrop) {
        self.currentLinePointY += self.waterRiseOrDropSpeed;
        self.peakHeightChange = 0.5;
        self.waveSpeedChange = 0.3;
        if (self.currentLinePointY >= self.savedWaveHeight) {
            self.waterDrop = NO;
            self.peakHeightChange = self.savedPeakHeightChange;
            self.waveSpeedChange = self.savedSpeedHeightChange;
            [self.delegate checkWaterDropOver:YES];
        }
    }
}

@end
