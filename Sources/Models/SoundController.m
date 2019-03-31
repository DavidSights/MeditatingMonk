//
//  Sounds.m
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/11/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import "SoundController.h"
#import <AVFoundation/AVFoundation.h>

//@interface SoundController ()
//
//@property (nonatomic)
//
//@end

@implementation SoundController {
    AVAudioPlayer *musicPlayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpMusicPlayer];
    }
    return self;
}

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

// MARK: - Sound Effects

- (void)playButtonSound {
    [self runAction:SoundController.button];
}

- (void)playGameOverSound {
    [self runAction:SoundController.gameOver];
}

- (void)playHighScoreSound {
    [self runAction:SoundController.highScore];
}

- (void)playJumpSound {
    [self runAction:SoundController.jump];
}

// MARK: - Music

- (void)setUpMusicPlayer {

    NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"musicLoop" ofType:@"wav"]];

    NSError *error;
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];

    if (error) {
        NSLog(@"There was an error loading music: %@", error);

    } else {
        musicPlayer.numberOfLoops = -1;
        [musicPlayer prepareToPlay];
    }
}

- (void)playMusic {
    if (musicPlayer.isPlaying == true) { return; }
    [musicPlayer play];
}

- (void)stopMusic {
    [musicPlayer stop];
    musicPlayer.currentTime = 0;
}

@end
