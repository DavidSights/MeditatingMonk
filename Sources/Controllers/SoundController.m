//
//  Sounds.m
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/11/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import "SoundController.h"
#import <AVFoundation/AVFoundation.h>

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

+ (SKAction *)gameOverSoundAction {
    return [SKAction playSoundFileNamed:@"gameOverSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)highScoreSoundAction {
    return [SKAction playSoundFileNamed:@"highScoreSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)jumpSoundAction {
    return [SKAction playSoundFileNamed:@"jumpSound.mp3" waitForCompletion:YES];
}

+ (SKAction *)buttonSoundAction {
    return [SKAction playSoundFileNamed:@"buttonSound.wav" waitForCompletion:YES];
}

// MARK: - Sound Effects

- (void)playButtonSound {
    [self runAction:SoundController.buttonSoundAction];
}

- (void)playGameOverSound {
    [self runAction:SoundController.gameOverSoundAction];
}

- (void)playHighScoreSound {
    [self runAction:SoundController.highScoreSoundAction];
}

- (void)playJumpSound {
    [self runAction:SoundController.jumpSoundAction];
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
