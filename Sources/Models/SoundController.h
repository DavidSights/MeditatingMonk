//
//  Sounds.h
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/11/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@interface SoundController : SKNode

+ (SKAction *)gameOver;
+ (SKAction *)highScore;
+ (SKAction *)jump;
+ (SKAction *)button;

// Sound effects
- (void)playButtonSound;
- (void)playGameOverSound;
- (void)playHighScoreSound;
- (void)playJumpSound;

// Music
- (void)playMusic;
- (void)stopMusic;

@end
