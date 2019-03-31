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

// Sound effects
- (void)playJumpSound;
- (void)playButtonSound;
- (void)playGameOverSound;
- (void)playHighScoreSound;

// Music
- (void)playMusic;
- (void)stopMusic;

@end
