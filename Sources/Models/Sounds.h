//
//  Sounds.h
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/11/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@interface Sounds : SKNode

+ (SKAction *)gameOver;
+ (SKAction *)highScore;
+ (SKAction *)jump;
+ (SKAction *)button;

- (void)playButtonSound;
- (void)playGameOverSound;
- (void)playHighScoreSound;
- (void)playJumpSound;

@end
