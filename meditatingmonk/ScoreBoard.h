//
//  menu.h
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/22/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreBoard : SKNode

@property (nonatomic) SKSpriteNode *scoreInfo, *replayButton, *gameCenterButton, *twitterButton, *facebookButton, *replayIcon, *gameCenterIcon;
@property (nonatomic) int score;
@property (nonatomic) long long highScore;
@property (nonatomic) CGSize size;


-(id)init:(CGSize) size;
- (void) showScore:(int) currentScore;
- (void) hideScore;

@end
