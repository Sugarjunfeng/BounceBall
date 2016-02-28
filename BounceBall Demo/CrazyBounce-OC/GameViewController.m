//
//  GameViewController.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle
     */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@interface GameViewController ()

@property GameScene* gameScene;
@property id<viewPassValueDelegate> delegate;

@property BOOL gameIsOver;
@property NSString* gamemode;
@property CGFloat waveHeight;

@end

@implementation GameViewController

#pragma mark - 控制器生存周期

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.gameIsOver) {
        self.gameIsOver = YES;
        
        // 添加游戏场景
        SKView* skView = (SKView*)self.view;
        skView.ignoresSiblingOrder = YES;
        
        self.gameScene = [[GameScene alloc]initWithSize:skView.bounds.size];
        self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
        self.gameScene.gameViewController = self;
        self.gameScene.saveCurrentTime = self.lbl_currentTime;
        self.gameScene.saveBestTime = self.lbl_bestTime;
        
        if ([self.gamemode  isEqual: @"Normal"]) {
            self.gameScene.gamemode = Normal;
        }else if ([self.gamemode  isEqual: @"Classic"]) {
            self.gameScene.gamemode = Classic;
        }else {
            self.gameScene.gamemode = Items;
        }
        [skView presentScene:self.gameScene];
        
        // 添加水面
        self.waveHeight = 120.0 / 568.0;
        self.waveHeight = self.waveHeight * self.view.frame.size.height;
        self.waterWaveView = [[waterView alloc]initWithFrame:self.view.bounds color:[UIColor colorWithRed:16.0/255.0 green:169.0/255.0 blue:240.0/255.0 alpha:1] waveHeight:self.waveHeight];
        self.waterWaveView.delegate = self;
        [self.waterWaveView waterDropDown];
        [self.view addSubview:self.waterWaveView];
        [self.view bringSubviewToFront:self.lbl_GameMode];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.gameIsOver = NO;
    self.lbl_GameMode.hidden = NO;
    uint32_t modeNumber = arc4random()%3 + 1;
    
    switch (modeNumber) {
        case 1:
            self.gamemode = @"Classic";
            self.lbl_GameMode.text = @"Classic Mode";
            break;
        case 2:
            self.gamemode = @"Normal";
            self.lbl_GameMode.text = @"Normal Mode";
            break;
        default:
            self.gamemode = @"Items";
            self.lbl_GameMode.text = @"Items Mode";
            break;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.gameScene removeAllChildren];
    [self.waterWaveView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - waterWaveViewDelegate

-(void)checkWaterDropOver:(BOOL)dropOver {
    if (dropOver) {
        NSLog(@"water drop down over");
        [self.gameScene startGame];
        self.gameScene.waveHeight = self.waveHeight;
        self.lbl_GameMode.hidden = YES;
        self.best = NO;
    }
}

-(void)checkWaterRiseOver:(BOOL)riseOver {
    if (riseOver) {
        NSLog(@"water rise up over");
        [self gameOver];
    }
}

#pragma mark - 游戏结束

-(void)gameOver {
    UIViewController* gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"gameOverView"];
    self.delegate = (GameOverViewController*) gameOverViewController;
    [self presentViewController:gameOverViewController animated:NO completion:nil];
    [self.delegate passValueWithCurrentTime:self.gameScene.lbl_currentTime.text BestTime:self.gameScene.lbl_bestTime.text GameMode:self.gamemode Best:self.best];
    self.gameIsOver = YES;
}

@end
