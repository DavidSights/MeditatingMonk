//
//  MyScene.h
//  MeditatingMonk
//

//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScoreBoard.h"
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "ViewController.h"
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import "CreditsNode.h"
#import <MessageUI/MessageUI.h>


@interface GameScene : SKScene <SKPhysicsContactDelegate, ADBannerViewDelegate, MFMailComposeViewControllerDelegate>

@property GKLocalPlayer *player;

- (void) loadHighScore;

@end
