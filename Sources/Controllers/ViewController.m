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

//@property (nonatomic) ADBannerView *myBanner;
@property (nonatomic) BOOL adReady, playingGame;
@property GameScene *scene;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Ask user to sign into GameCenter.
//    [self authenticateLocalPlayer];

    self.playingGame = YES;

    // Set up sprite kit view.

    // Set to self.originalContentView instead of self.view because of this problem: http://goo.gl/EshbYn
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;

    self.scene = [GameScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:self.scene];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(showGameCenter)
                                               name:@"showGameCenter"
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(emailDavid)
                                               name:@"emailDavid"
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(emailDavy)
                                               name:@"emailDavy"
                                             object:nil];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Game Center

- (void) authenticateLocalPlayer {
    __weak typeof(self) weakSelf = self;
    self.localPlayer = [GKLocalPlayer localPlayer];
    self.localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [weakSelf presentViewController:viewController animated:YES completion:nil];
        }
        else if (weakSelf.localPlayer.isAuthenticated) {
            NSLog(@"Player is authenticated: %@", weakSelf.localPlayer);
            weakSelf.scene.player = weakSelf.localPlayer;
            [weakSelf.scene loadHighScore];
        }
        else {
            NSLog(@"Player not authenticated.");
        }
    };
}

- (void) showGameCenter {
    GKGameCenterViewController *gameCenterController = [GKGameCenterViewController new];

    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.leaderboardIdentifier = @"highScoreLB";
        [self presentViewController: gameCenterController animated: YES completion:nil];
        
        [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
            NSLog(@"ViewController -showGameCenter: Loading leaderboard with identifier: %@", leaderboardIdentifier);
            
            if (error) {
                NSLog(@"ViewController - showGameCenter: There was an error while loading the leaderboard: %@", error);
            }
            else {
                NSLog(@"ViewController -showGameCenter: Leaderboard displayed.");
            }
        }];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Email

-(void)emailDavid {
    [self composeEmailWithSubject:@"Email from Meditating Monk"
                          message:@"Hi Davy, I'm emailing you from the Meditating Monk game. "
                     toRecipients:@[@"davidseitzjr@gmail.com"]];
}

-(void)emailDavy {
    [self composeEmailWithSubject:@"Email from Meditating Monk"
                          message:@"Hi David, I'm emailing you from the Meditating Monk game."
                     toRecipients:@[@"davyowolfmusic@gmail.com"]];
}

- (void)sendContactEmail {
    
}

/// Create and show an email composition view.
- (void)composeEmailWithSubject:(NSString *)subject message:(NSString *)message toRecipients:(NSArray<NSString*> *)recipients {
    MFMailComposeViewController *mc = [MFMailComposeViewController new];
    mc.mailComposeDelegate = self;
    [mc setSubject:subject];
    [mc setMessageBody:message isHTML:NO];
    [mc setToRecipients:recipients];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
