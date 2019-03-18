//
//  Sounds.m
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/11/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import "Sounds.h"

@implementation Sounds

+ (SKAction *)gameOver {
    return [SKAction playSoundFileNamed:@"gameOverSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)highScore {
    return [SKAction playSoundFileNamed:@"highScoreSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)jump {
    return [SKAction playSoundFileNamed:@"jumpSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)button {
    return [SKAction playSoundFileNamed:@"buttonSound.wav" waitForCompletion:YES];
}

- (void)playButtonSound {
    [self runAction:Sounds.button];
}

- (void)playGameOverSound {
    [self runAction:Sounds.gameOver];
}

- (void)playHighScoreSound {
    [self runAction:Sounds.highScore];
}

- (void)playJumpSound {
    [self runAction:Sounds.jump];
}

@end
