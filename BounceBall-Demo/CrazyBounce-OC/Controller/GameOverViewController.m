//
//  GameOverViewController.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-06.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@property id<viewPassValueDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbl_gamemode;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BestTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Catalog;
@property (weak, nonatomic) IBOutlet UIImageView *img_HighScore;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* Tips = @{
                           @0:@"提示：摁住滑块不要让小球掉下来",
                           @1:@"不要快速移动滑块，别怪我没提醒你",
                           @2:@"那么我们的问题就来了",
                           @3:@"挖掘机技术到底哪家强",
                           @4:@"开发程序猿能坚持25秒哦！",
                           @5:@"怪我咯？",
                           @6:@"我也是醉了",
                           @7:@"我想请你吃麻辣烫",
                           @8:@"我只想做一个安静的美男子",
                           @9:@"我想起那夕阳下的奔跑，那是我逝去的青春",
                           @10:@"万万没想到，最后我还是死了",
                           @11:@"23333333333",
                           @12:@"我是小学生不太会说话",
                           @13:@"有什么说的不对的地方，你TM来打我呀",
                           @14:@"我读书少你别骗我",
                           @15:@"你很有天赋，跟我学做菜吧",
                           @16:@"不是说好做彼此的天使吗?",
                           @17:@"仰望天空45度的忧伤",
                           @18:@"画面太美我不敢看",
                           @19:@"他说的好有道理我竟然无言以对",
                           @20:@"why are you so diao?",
                           @21:@"不要在意这些细节",
                           @22:@"我和我的小伙伴们都惊呆了",
                           @23:@"你TM在逗我？",
                           @24:@"呵呵",
                           @25:@"我是Crazy Bounce，我为自己代言",
                           @26:@"土豪，我们做朋友吧！",
                           @27:@"我这是要火的节奏啊",
                           @28:@"弹~弹~弹~弹走鱼尾纹",
                           @29:@"no zuo no die why you try",
                           @30:@"no try no high give me five",
                           @31:@"why try why high can't be shine",
                           @32:@"you shine you try still go die",
                           @33:@"小秘密：点两下就可以暂停哟~"
    };
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:169.0/255.0 blue:240.0/255.0 alpha:1];
    self.img_HighScore.hidden = YES;
    
    self.lbl_Catalog.text = Tips[@(arc4random()%33)];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)passValueWithCurrentTime:(NSString *)currentTime BestTime:(NSString *)bestTime GameMode:(NSString *)gamemode Best:(BOOL)best {
    NSLog(@"currentTime: %@, bestTime: %@", currentTime, bestTime);
    self.lbl_CurrentTime.text = currentTime;
    self.lbl_BestTime.text = bestTime;
    if (best) {
        self.img_HighScore.hidden = NO;
    }
    self.lbl_gamemode.text = gamemode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)gameRestart:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
