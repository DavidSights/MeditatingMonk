//
//  ViewController.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "GameScenePresenterViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

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
}

// MARK: - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:true
                     completion:nil];
}

@end
