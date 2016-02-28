//
//  FileManager.m
//  CrazyBounce-OC
//
//  Created by 星夜暮晨 on 2015-05-04.
//  Copyright (c) 2015 益行人. All rights reserved.
//

#import "FileManager.h"

@interface FileManager ()

@property NSString* filename;

@end

@implementation FileManager

#pragma mark - 初始化方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filename = [self filePathWithFileName:@"time.plist"];
    }
    return self;
}

#pragma mark - 写入读出方法

/// 读取文件
-(void) loadFile {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filename]) {
        NSArray* data = [[NSArray alloc]initWithContentsOfFile:self.filename];
        
        self.bestTimeClassic = [data objectAtIndex:0];
        self.bestTimeNormal = [data objectAtIndex:1];
        self.bestTimeIdems = [data objectAtIndex:2];
    } else {
        NSArray* data = @[@0, @0, @0];
        self.bestTimeNormal = @0;
        self.bestTimeIdems = @0;
        self.bestTimeClassic = @0;
        [data writeToFile:self.filename atomically:YES];
    }
    NSLog(@"file load over, the data are Classic: %@, Normal: %@, Items: %@", self.bestTimeClassic, self.bestTimeNormal, self.bestTimeIdems);
}

/// 将数据写入文件
-(void) writeFileOfMode: (gameMode) mode WithTime:(NSNumber*)time {
    switch (mode) {
        case Classic:
            self.bestTimeClassic = time;
            break;
        case Normal:
            self.bestTimeNormal = time;
            break;
        case Items:
            self.bestTimeIdems = time;
            break;
        default:
            break;
    }
    NSArray* data = @[self.bestTimeClassic, self.bestTimeNormal, self.bestTimeClassic];
    [data writeToFile:self.filename atomically:YES];
}

#pragma mark - 私有方法

/// 文件路径函数
-(NSString*) filePathWithFileName: (NSString*)fileName {
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docPath = [path objectAtIndex:0];
    NSString* filePath = [docPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

@end
