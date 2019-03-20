//
//  menu.h
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/22/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreBoard : SKNode

@property (nonatomic) int score;
@property (nonatomic) long long highScore;

- (id)init:(CGSize)size;
- (void)showScore:(int)currentScore;
- (void)hideScore;

@end
