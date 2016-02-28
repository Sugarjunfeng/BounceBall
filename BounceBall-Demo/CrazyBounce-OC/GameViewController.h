//
//  GameViewController.h
//  CrazyBounce-OC
//

//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "waterView.h"
#import "GameElements.h"
#import "GameOverViewController.h"

@interface GameViewController : UIViewController <waterViewDelegate, viewPassValueDelegate>

@property BOOL best;
@property waterView* waterWaveView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_GameMode;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_bestTime;


@end
