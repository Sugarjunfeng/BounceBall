//
//  GameBeginViewController.h
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "waterView.h"

@interface GameBeginViewController : UIViewController <waterViewDelegate>

@property waterView* waterWaveView;
@property CGFloat waveHeight;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end
