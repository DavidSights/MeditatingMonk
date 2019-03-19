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
@property GameScene *scene;
@end

@implementation ViewController

// MARK: - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up and show the game scene.
    SKView *skView = (SKView *)self.view;
    self.scene = [GameScene sceneWithSize:skView.bounds.size];
    [skView presentScene:self.scene];

#if DEBUG
    skView.showsFPS = true;
    skView.showsNodeCount = true;
#endif
}

// MARK: - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
