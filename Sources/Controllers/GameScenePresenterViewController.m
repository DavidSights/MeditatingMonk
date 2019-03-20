//
//  ViewController.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "GameScenePresenterViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "GameScene.h"
#import "MeditatingMonk-Swift.h"

@interface GameScenePresenterViewController () <GameSceneDelegate>
@property GameScene *gameScene;
@end

@implementation GameScenePresenterViewController

// MARK: - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up and show the game scene.
    SKView *skView = (SKView *)self.view;
    self.gameScene = [GameScene sceneWithSize:skView.bounds.size];
    self.gameScene.gameSceneDelegate = self;
    [skView presentScene:self.gameScene];

#if DEBUG
    skView.showsFPS = true;
    skView.showsNodeCount = true;
#endif
}

// MARK: - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

// MARK: - Convenience Methods

/// Shows an alert that allows the user to reset their score.
- (void)showScoreResetOption {

    UIAlertController *secretResetAlert = [UIAlertController alertControllerWithTitle:@"Secret Reset Option"
                                                                              message:@"Would you like to reset your score?"
                                                                       preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#if DEBUG
        NSLog(@"User attempted to show the score reset option, but it hasn't been implemented yet.");
#endif
        // TODO: Set up reset score functionality.
        // Might want to create a data manager that can be called from here.
    }];

    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [secretResetAlert addAction:yesAction];
    [secretResetAlert addAction:noAction];

    [self presentViewController:secretResetAlert
                       animated:true
                     completion:nil];
}

@end
