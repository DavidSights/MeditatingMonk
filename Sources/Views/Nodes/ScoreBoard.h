//
//  menu.h
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/22/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString * const facebookNodeId;
extern NSString * const twitterNodeId;

@interface ScoreBoard : SKNode

@property (nonatomic) int score;
@property (nonatomic) long long highScore;

- (id)init:(CGSize)size;
- (void)showScore;
- (void)hideScore;
- (void)reloadData;

@end
