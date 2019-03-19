//
//  ViewController.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"

@interface ViewController()

@property (nonatomic) BOOL adReady;
@property (nonatomic) BOOL playingGame;
@property GameScene *scene;

@end


@implementation ViewController

// MARK: - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playingGame = YES;

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;

    self.scene = [GameScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:self.scene];
}

// MARK: - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
