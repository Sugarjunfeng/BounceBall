//
//  GameBeginViewController.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "GameBeginViewController.h"

@interface GameBeginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn_gameBegin;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

@end

@implementation GameBeginViewController

#pragma mark - 生存周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProperty];
    self.waveHeight = self.view.frame.size.height * self.waveHeight;
    self.waterWaveView = [[waterView alloc]initWithFrame:self.view.bounds color:[[UIColor alloc]initWithRed:16.0/255.0 green:169.0/255.0 blue:240.0/255.0 alpha:1] waveHeight:self.waveHeight];
    NSLog(@"%f",self.waveHeight);
    self.waterWaveView.delegate = self;
    
    [self.view insertSubview:self.waterWaveView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 动作
- (IBAction)GameBegin:(UIButton *)sender {
    [self.waterWaveView waterRiseUp];
    [self.view sendSubviewToBack:self.img_logo];
    [self.view sendSubviewToBack:self.btn_gameBegin];
}

#pragma mark - Water Wave View Delegate

-(void)checkWaterRiseOver:(BOOL)riseOver {
    if (riseOver) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"gameStart" sender:self];
    }
}

#pragma mark - 私有方法

-(void) initProperty {
    self.waveHeight = 120.0 / 568.0;
}

@end
