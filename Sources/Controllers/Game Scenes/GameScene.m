//
//  MyScene.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import <Social/Social.h>
#import "GameScenePresenterViewController.h"
#import "GameScene.h"
#import "Sounds.h"
#import "TipCloud.h"
#import "ScoreBoard.h"
#import "CreditsNode.h"
#import "MeditatingMonk-Swift.h"

enum GameState {
    title,
    newGame,
    playing,
    scoreboard,
    credits
};

@interface GameScene () <SKPhysicsContactDelegate>

@property enum GameState gameState;

@property GKLocalPlayer *player;

// Flags
@property (nonatomic) BOOL gameActive, scoreShown, timerStarted, monkHitSomething, gameStarted, gameFinished, musicPlaying, creditsShowing, firstHop;

// Views
@property SKSpriteNode *monkNode, *background, *grassAndTree, *clouds1, *clouds2, *tipBackground;
@property SKLabelNode *scoreLabel, *scoreLabelDropShadow;

// Actions
@property SKAction *openEyes, *closeEyes;
@property SKNode *grassEdge, *branchEdge;

@property int secretResetOptionCounter;

@property (nonatomic) NSArray *loadedAchievements;
@property (nonatomic) GKScore *retrievedScore;

/// A controller for social features, like posting to Twitter and Facebook.
@property (strong, nonatomic) SLComposeViewController *SLComposeVC;

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@property (nonatomic) ScoreBoard *scoreboard;
@property CreditsNode *credits;

@property Sounds *sounds;

@end

// Category bitmasks - used for edges and collision detection
static const uint32_t monkCategory = 0x1;
static const uint32_t treeCategroy = 0x1 << 1;
static const uint32_t grassCategory = 0x1 << 2;

static const NSString *updateScoreActionKey = @"updateScoreTimer";

@implementation GameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        self.gameState = title;

        [self initialFlagsSetup];

        [self deviceSpecificSetupWithSize:size];
        [self setUpScoreboard];

        [self setUpAndShowTitleViews];

        [self addClouds];

        [self setUpMusic];

        [self setupCredits];

        self.sounds = [Sounds new];
        [self addChild:self.sounds];

        self.gameStarted = NO;
    }

    return self;
}

- (void)setupCredits {

    CGSize size = self.view.frame.size;

    self.credits = [[CreditsNode alloc] init:size];
    self.credits.position = CGPointMake(size.width/2, size.height/2);
    self.credits.name = @"credits node view";
    self.creditsShowing = NO;
}

- (void)setUpScoreboard {

    int scoreLabelFontSize = DeviceManager.isTablet ? 60 : 30;
    CGPoint scoreLabelPosition = CGPointMake(self.size.width / 2, self.size.height + 10);

    // Set up score label drop shadow. There has to be a better way to do this.
    self.scoreLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.scoreLabelDropShadow.text = @"0";
    self.scoreLabelDropShadow.fontSize = scoreLabelFontSize;
    [self.scoreLabelDropShadow setFontColor:[SKColor blackColor]];
    self.scoreLabelDropShadow.name = @"currentScoreLabelDropShadow";
    self.scoreLabelDropShadow.position = scoreLabelPosition;
    [self addChild:self.scoreLabelDropShadow];

    // Set up score label
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.scoreLabel.text = @"0";
    self.scoreLabel.fontSize = scoreLabelFontSize;
    [self.scoreLabel setFontColor:[SKColor whiteColor]];
    self.scoreLabel.name = @"currentScoreLabel";
    self.scoreLabel.position = scoreLabelPosition;
    [self addChild:self.scoreLabel];

    // Set up scoreboard.
    self.scoreboard = [[ScoreBoard alloc] init:self.size];
    self.scoreboard.position = CGPointMake(self.size.width/2, self.size.height * 2);
    [self addChild:self.scoreboard];
}

- (void)initialFlagsSetup {
    self.gameActive = NO;
    self.firstHop = NO;
    self.scoreShown = NO;
    self.monkHitSomething = NO;
}

- (void) deviceSpecificSetupWithSize:(CGSize)size {

    self.backgroundColor = [SKColor colorWithRed:0.15
                                           green:0.15
                                            blue:0.3
                                           alpha:1.0];
    [self addBackground:size];
    [self addMonk:size];
    [self addGrassEdge:size];
    [self addBranchEdge:size];

    self.physicsWorld.contactDelegate = self;

    if (!DeviceManager.isTablet) {
        // Set up for iPhone
        self.openEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monkAwake@2x" ofType:@"png" ]]];
        self.closeEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monk@2x" ofType:@"png"]]];

    } else {
        // Set up for iPad
        self.openEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monkEyesOpeniPad@2x" ofType:@"png" ]]];
        self.closeEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monkiPad@2x" ofType:@"png"]]];
    }
}

# pragma mark - Audio

- (void)setUpMusic {

    NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"musicLoop" ofType:@"wav"]];
    NSError *error;

    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];

    if (error) {
        NSLog(@"There was an error loading music: %@", error);
    } else {
        self.musicPlayer.numberOfLoops = -1;
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }

    self.musicPlaying = YES;
}

- (void)stopMusic {
    [self.musicPlayer stop];
    self.musicPlayer.currentTime = 0;
    self.musicPlaying = NO;
}

#pragma mark - Set Up Scene

- (void)addMonk:(CGSize)size {

    BOOL deviceIsPad = size.width == 768 && size.height == 1024;
    
    if (!deviceIsPad) {
        // Set up for iPhone
        self.monkNode = [SKSpriteNode spriteNodeWithImageNamed:@"monk"];
        
    } else {
        // Set up for iPad
        self.monkNode = [SKSpriteNode spriteNodeWithImageNamed:@"monkiPad"];
        self.monkNode.physicsBody.mass = 2.1; // Monk is too heavy on ipad without changing mass.
    }

    self.monkNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.monkNode.size];
    self.monkNode.position = CGPointMake(size.width/2, size.height/2);
    self.monkNode.physicsBody.categoryBitMask = monkCategory;
    self.monkNode.physicsBody.contactTestBitMask = treeCategroy | grassCategory;

    [self addChild:self.monkNode];
}

- (void)addBackground:(CGSize)size {

    if (self.background != nil && self.grassAndTree != nil) {
        // Prevent setting up objects again.
        return;
    }

    // Set up background objects.
    self.background = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"backgroundiPad" : @"backgroundiPhone")];
    self.grassAndTree = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"grassAndTreeiPad" : @"grassAndTreeiPhone")];
    self.background.position = CGPointMake(size.width/2, size.height/2);
    self.grassAndTree.position = CGPointMake(size.width/2, size.height/2);

    // Show background elements.
    [self addChild:self.background];
    [self addChild:self.grassAndTree];
}

- (void)addGrassEdge:(CGSize)size {

    self.grassEdge = [SKNode node];

    //Prepare image for 4 inch screen
    if (size.height == 568 && size.width == 320) {
        self.grassEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 126) toPoint:CGPointMake(size.width, 126)];
    }

    //Prepare edge for 3.5 inch screen
    if (size.width == 320 && size.height == 480) {
        float grassEdge = 49;
        self.grassEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, grassEdge) toPoint:CGPointMake(size.width, grassEdge)];
    }

    //Prepare for iPad
    if (size.width == 768 && size.height == 1024) {
        int grassEdgeLocation = 38;
        self.grassEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, grassEdgeLocation) toPoint:CGPointMake(size.width, grassEdgeLocation)];
    }

    self.grassEdge.physicsBody.dynamic = NO;
    self.grassEdge.physicsBody.categoryBitMask = grassCategory;

    [self addChild:self.grassEdge];
}

- (void) addBranchEdge:(CGSize) size {

    self.branchEdge = [SKNode node];

    //Prepare image for 4 inch screen
    if (size.height == 568 && size.width == 320) {
        self.branchEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, (size.height/20)*17) toPoint:CGPointMake(size.width, (size.height/20)*17)];
    }

    if (size.width == 320 && size.height == 480) {
        float branchEdge = 410;
        self.branchEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, branchEdge) toPoint:CGPointMake(size.width, branchEdge)];
    }

    //Prepare for iPad
    if (size.width == 768 && size.height == 1024) {
        self.branchEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, ((size.height/20) * 17)) toPoint:CGPointMake(size.width, (size.height/20)*17)];
    }

    self.branchEdge.physicsBody.dynamic = NO;
    self.branchEdge.physicsBody.categoryBitMask = treeCategroy;

    [self addChild:self.branchEdge];
}

- (void)setUpClouds {
    self.clouds1 = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"clouds1iPad" : @"clouds1")];
    self.clouds2 = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"clouds2iPad" : @"clouds2")];
    self.clouds1.anchorPoint = CGPointMake(0, 0.5);
    self.clouds2.anchorPoint = CGPointMake(0, 0.5);
    self.clouds1.position = CGPointMake(self.size.width, 80);
    self.clouds2.position = CGPointMake(self.size.width, 80);
}

- (void) addClouds {
    [self setUpClouds];
    CGPoint cloudDestination = CGPointMake((0 -(self.size.width/2)) - (self.clouds1.size.width),100);
    CGPoint cloudStart = CGPointMake(self.size.width, 100);
    SKAction *moveClouds = [SKAction moveTo:cloudDestination duration:20];
    SKAction *returnClouds = [SKAction moveTo:cloudStart duration:0];
    [self.background addChild:self.clouds1];
    [self.background addChild:self.clouds2];
    [self.clouds1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveClouds, returnClouds]]]];
    [self.clouds2 runAction:[SKAction sequence:@[[SKAction waitForDuration:10],[SKAction repeatActionForever:[SKAction sequence:@[moveClouds, returnClouds]]]]]];
}

#pragma mark - Grpahics and Animations

- (void)hideTitleLabels {

    if (self.gameStarted == NO) {

        SKAction *fade = [SKAction fadeOutWithDuration:.25];
        SKAction *remove  = [SKAction removeFromParent];

        [self enumerateChildNodesWithName:@"startLabel" usingBlock:^(SKNode *node, BOOL *stop) {
            [node runAction:[SKAction sequence:@[fade, remove]]];
        }];
    }
}

- (void)setUpAndShowTitleViews {

    int taptoStartFontSize = 20;
    int directionsFontSize = 14;
    float dropShadowDistance = (DeviceManager.isTablet ? 3.8 : 2.5);
    float dropShadowDistance2 = (DeviceManager.isTablet ? 3.8 : 2);

    // Set up the title.
    SKSpriteNode *titleImageNode = [SKSpriteNode spriteNodeWithImageNamed: (!DeviceManager.isTablet ? @"title" : @"titleiPad")];
    titleImageNode.position = CGPointMake(self.size.width/2, (!DeviceManager.isTablet ? 440 : 800));
    titleImageNode.name = @"startLabel";
    [self addChild:titleImageNode];

    // Note: Drop shadows are being created here by creating a second label
    // to serve as the drop shadown, which is positioned just beneath its corresponding label.

    // Set up labels.

    SKLabelNode *tapToStartLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    tapToStartLabel.text = @"tap to float";
    tapToStartLabel.name = @"startLabel";
    [tapToStartLabel setFontColor:SKColor.whiteColor];
    tapToStartLabel.fontSize = taptoStartFontSize;
    tapToStartLabel.position = CGPointMake(self.size.width/2, (DeviceManager.isTablet ? 100 : 90));
    [self addChild:tapToStartLabel];

    SKLabelNode *tapToStartLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    tapToStartLabelDropShadow.text = tapToStartLabel.text;
    tapToStartLabelDropShadow.name = @"startLabel";
    [tapToStartLabelDropShadow setFontColor:SKColor.blackColor];
    tapToStartLabelDropShadow.fontSize = taptoStartFontSize;
    tapToStartLabelDropShadow.position = CGPointMake(tapToStartLabel.position.x + dropShadowDistance, tapToStartLabel.position.y - dropShadowDistance);
    [self addChild:tapToStartLabelDropShadow];

    SKLabelNode *directionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    directionsLabel.text = @"don't hit the tree or ground";
    directionsLabel.name = @"startLabel";
    [directionsLabel setFontColor:SKColor.whiteColor];
    directionsLabel.fontSize = directionsFontSize;
    directionsLabel.position = CGPointMake(self.size.width/2, tapToStartLabel.position.y - (DeviceManager.isTablet ? 50 : 20));
    [self addChild:directionsLabel];

    SKLabelNode *directionsLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    directionsLabelDropShadow.text = directionsLabel.text;
    directionsLabelDropShadow.name = @"startLabel";
    [directionsLabelDropShadow setFontColor:SKColor.blackColor];
    directionsLabelDropShadow.fontSize = directionsFontSize;
    directionsLabelDropShadow.position = CGPointMake(directionsLabel.position.x + dropShadowDistance2, directionsLabel.position.y - dropShadowDistance2);
    [self addChild:directionsLabelDropShadow];

    SKAction *hideAction = [SKAction fadeOutWithDuration:0];
    SKAction *waitAction = [SKAction waitForDuration:.35];
    SKAction *showAction = [SKAction fadeInWithDuration:0];
    NSArray<SKAction*> *actionSequence = @[hideAction, waitAction, showAction, waitAction];
    SKAction *blink = [SKAction repeatActionForever:[SKAction sequence:actionSequence]];

    NSArray<SKLabelNode*> *blinkingLabels = @[tapToStartLabel,
                                              tapToStartLabelDropShadow,
                                              directionsLabel,
                                              directionsLabelDropShadow];

    for (SKLabelNode *label in blinkingLabels) {
        [label runAction:blink];
    }
}

- (void) showCredits {

    if (self.credits == nil) {
        NSLog(@"CREDITS IS NIL");
    }

    self.credits.position = CGPointMake(self.size.width/2, self.size.height *2);
    self.credits.alpha = 0;

    [self addChild:self.credits];
    [self.credits runAction:[SKAction fadeInWithDuration:.4]];
    [self.credits runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.3]];
    self.creditsShowing = YES;
}

- (void) hideCredits {

    [self.credits runAction:[SKAction fadeOutWithDuration:.15] completion:^{
        [self.credits removeFromParent];
        self.creditsShowing = NO;
    }];
}

- (void)showScoreLabelIfNecessary {

    int scoreLabelYPosition = (self.size.height - (DeviceManager.isTablet ? 80 : 47));
    float dropShadowOffset = (DeviceManager.isTablet ? 3.9 : 3.7);

    // Prevent unnecessarily setting up the score label again.
    if (self.scoreLabel.position.y == scoreLabelYPosition) { return; }

    // Reset the score to show a new score counter.
    DataManager.currentScore = 0;
    NSString *currentScoreString = [NSString stringWithFormat:@"%li", (long)DataManager.currentScore];
    self.scoreLabel.text = currentScoreString;
    self.scoreLabelDropShadow.text = currentScoreString;

    // Show the score label with animation.
    [self.scoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, scoreLabelYPosition) duration:.5]];
    [self.scoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + dropShadowOffset, (scoreLabelYPosition - dropShadowOffset)) duration:.5]];

    self.scoreShown = true;
}

- (void)hideScoreLabel {

    float DS = 3.7;
    if (self.size.height == 1024 && self.size.width == 768) { DS = DS + 10; }


    //set and run animation for actual label to hide
    [self.scoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, (self.size.height + 50)) duration:.5]];
    //set and run animation for dropshadow hide
    [self.scoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + DS, self.size.height + (50 + DS)) duration:.5]];
    self.scoreShown = NO;
}

- (void)showEnlighteningThought {
    TipCloud *tip = [TipCloud new];
    [tip positionWithFrame:self.frame];
    [self addChild:tip];
}

- (void)hideTip {

    // Is it possible to make this an instance method and call it without using a property?
    [self enumerateChildNodesWithName:@"tip" usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *fade = [SKAction fadeOutWithDuration:.25];
        SKAction *remove  = [SKAction removeFromParent];
        [node runAction:[SKAction sequence:@[fade, remove]]];
    }];
}

#pragma mark - Physics

- (void)makeMonkJump {

    switch (self.gameState) {

        case newGame:
            self.gameState = playing;
            return [self.monkNode.physicsBody applyImpulse:PhysicsManager.newGameJump];

        case playing:
            return [self.monkNode.physicsBody applyImpulse:PhysicsManager.jump];

        default:
            return;
    }
}

- (void)beginCountingScoreIfNecessary {

    // Prevent animating the current score/timer unnecessarily.
    if ([self actionForKey:updateScoreActionKey] != nil) { return; }

    NSArray<SKAction*> *actions = @[[SKAction waitForDuration:1],
                                    [SKAction performSelector:@selector(incrementScore) onTarget:self]];

    [self runAction: [SKAction repeatActionForever:[SKAction sequence:actions]] withKey:updateScoreActionKey];
}

#pragma mark - Interaction

- (void)triggerGameAction {
    [self beginCountingScoreIfNecessary];
    [self showScoreLabelIfNecessary];

    DataManager.totalTaps = DataManager.totalTaps + 1;

    // Monk actions
    [self makeMonkJump];
    [self.sounds playJumpSound];
    [self.monkNode runAction:self.closeEyes];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.gameState == title) {
        [self hideTitleLabels];
        self.gameState = newGame;
        return;
    }

    if (self.gameState == playing || self.gameState == newGame) {
        [self triggerGameAction];
        return;
    }

    for (UITouch *touch in touches) {

        if (self.gameState == scoreboard) {

            /// The node that was touched by the user.
            SKNode *scoreboardNode = [self.scoreboard nodeAtPoint:[touch locationInNode:self.scoreboard]];

            if ([scoreboardNode.name isEqual: @"replayButton"]) { [self replayButtonPressed]; }

            if ([scoreboardNode.name isEqual:@"gameCenterButton"]) {
                // TODO: Remove game center functionality for now. The button should be removed first.
                [self.sounds playButtonSound];
                [self gameCenterButtonPressed];
            }

            if ([scoreboardNode.name isEqual:@"twitterButton"] && self.creditsShowing == NO) {

                [self.sounds playButtonSound];

                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                    self.SLComposeVC = [SLComposeViewController new];
                    self.SLComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

                    NSString *shareText = [[NSString alloc] initWithFormat:@"Just scored %li! Can you beat my score? #MonkGame https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8", DataManager.currentScore];

                    [self.SLComposeVC setInitialText:shareText];

                    UIImage *screenshotImage = [ImageManager screenshotImageWithView:self.view];

                    [self.SLComposeVC addImage:screenshotImage];

                    UIViewController *controller = self.view.window.rootViewController;
                    [controller presentViewController:self.SLComposeVC animated: YES completion:nil];

                    [self.SLComposeVC setCompletionHandler:^(SLComposeViewControllerResult result) {
                        NSString *output = [[NSString alloc] init];
                        switch (result) {
                            case SLComposeViewControllerResultCancelled:
                                output = @"cancelled";
                                break;
                            case SLComposeViewControllerResultDone:
                                output = @"done";
                                break;
                            default:
                                break;
                        }
                        if ([output isEqual: @"cancelled"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"You did not share your score." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                        }
                        if ([output isEqualToString:@"done"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"You successfully shared your score!" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
                }
                else {
                    UIAlertView *noTwitterAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not share to Twitter. Please make sure you are signed into your Twitter account in your device's settings." delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
                    [noTwitterAlert show];
                }
            }
            if ([scoreboardNode.name isEqual:@"facebookButton"] && self.creditsShowing == NO) {

                [self.sounds playButtonSound];

                // Share to facebook
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    self.SLComposeVC = [[SLComposeViewController alloc] init];
                    self.SLComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

                    NSString *shareText = [[NSString alloc] initWithFormat:@"Just scored %li! Can you beat my score? #MonkGame https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8", DataManager.currentScore];

                    [self.SLComposeVC setInitialText:shareText];

                    //Take a screenshot and set it equal to UIImage *scoreImage
                    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
                    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
                    UIImage *scoreImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();

                    [self.SLComposeVC addImage:scoreImage];

                    UIViewController *controller = self.view.window.rootViewController;
                    [controller presentViewController:self.SLComposeVC animated: YES completion:nil];

                    [self.SLComposeVC setCompletionHandler:^(SLComposeViewControllerResult result) {
                        NSString *output = [[NSString alloc] init];
                        switch (result) {
                            case SLComposeViewControllerResultCancelled:
                                output = @"cancelled";
                                break;
                            case SLComposeViewControllerResultDone:
                                output = @"done";
                                break;
                            default:
                                break;
                        }
                        if ([output isEqual: @"cancelled"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You did not share your score." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                        }
                        if ([output isEqualToString:@"done"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You successfully shared your score!" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not share to Facebook. Please make sure you are signed into your Facebook account in your device's settings." delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
                    [alert show];
                }
            }
            if ([scoreboardNode.name isEqual: @"creditsButton"] && self.creditsShowing == NO) {

                [self.sounds playButtonSound];

                [self showCredits];
                _secretResetOptionCounter = 0;
            }
        }

        //If credits are showing, check for any buttons pressed within the credits node.
        if (self.creditsShowing == YES) {
            for (UITouch *touch in touches) {

                SKNode *creditsNode = [self.credits nodeAtPoint:[touch locationInNode:self.credits]];

                if ([creditsNode.name isEqual:@"davidTwitter"]) {

                    [self.sounds playButtonSound];

                    NSLog(@"David twitter button pressed");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/davidsights"]];
                }

                if ([creditsNode.name isEqual:@"davyTwitter"]) {

                    [self.sounds playButtonSound];
                    NSLog(@"davy twitter button pressed");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/davywolfmusic"]];
                }

                if ([creditsNode.name isEqual:@"goBack"]) {

                    [self.sounds playButtonSound];

                    [self hideCredits];
                    self.secretResetOptionCounter = 0;
                }

                if ([creditsNode.name isEqual:@"rate"]) {
                    // TODO: Use in app rating request.

                    [self.sounds playButtonSound];

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8"]];
                }

                if ([creditsNode.name isEqual:@"davidEmail"]) {
                    [self.sounds playButtonSound];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailDavid" object:self];
                }
                if ([creditsNode.name isEqual:@"davyEmail"]) {
                    [self.sounds playButtonSound];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailDavy" object:self];
                }
            }
        }
    }

    if (self.gameStarted == NO) {
        // Allows dismissal of UI that appears when app is launched.
        self.gameStarted = YES;
        self.gameActive = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Yes"]){
        [DataManager resetHighScore];
        self.secretResetOptionCounter = 0;
    } else if ([title isEqualToString:@"No"]) {
        self.secretResetOptionCounter = 0;
        NSLog(@"MyScene -alertView: Scores were not reset.");
    }
}

- (void)replayButtonPressed {
    [self.scoreboard hideScore];
    [self hideTip];

    if (self.musicPlaying == NO) {
        [self.musicPlayer play];
        self.musicPlaying = YES;
        self.secretResetOptionCounter = 0;
    }

    self.gameState = newGame;
}

- (void)gameCenterButtonPressed {
    [self.gameSceneDelegate showAlertWithTitle:@"GameCenter Disabled"
                                       message:@"Sorry. GameCenter is temporarily disabled. This feature will be fixed or removed on future versions"];
}

#pragma mark - Collisions

-(void)didBeginContact:(SKPhysicsContact*)contact {

    SKPhysicsBody *notTheMonk;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheMonk = contact.bodyB;
    }
    else {
        notTheMonk = contact.bodyA;
    }

    if (notTheMonk.categoryBitMask == treeCategroy) {
        [self touchedTree];
    }

    if (notTheMonk.categoryBitMask == grassCategory) {
        [self touchedGrass];
    }
}

/// Handles all behavior related to the end of a game.
- (void)endGame {

    if (self.gameState != playing) { return; }

    // Stop the timer.
    [self removeActionForKey:updateScoreActionKey];
    self.timerStarted = NO;

    [self.monkNode runAction:self.openEyes];

    [self hideScoreLabel];

    [self.scoreboard reloadData];
    [self showScoreBoardAndHideScoreCounter];
    [self updateSavedScores];

    DataManager.combinedScores += DataManager.currentScore;

    if (DataManager.currentScore >= 10) {
        [self showEnlighteningThought];
    }

    // Handle music
    [self.musicPlayer stop];
    self.musicPlayer.currentTime = 0;
    self.musicPlaying = NO;

    self.firstHop = NO;
}

/// Updates the high score if necessary, and plays a sound based on score.
- (void)updateSavedScores {
    if (DataManager.currentScore > DataManager.highScore) {
        DataManager.highScore = DataManager.currentScore;
        [self.sounds playHighScoreSound];
    } else {
        [self.sounds playGameOverSound];
    }
}

- (void)touchedTree {
    [self endGame];
}

- (void)touchedGrass {
    [self endGame];
}

#pragma mark - Score

- (void)incrementScore {
    DataManager.currentScore = DataManager.currentScore + 1;
    NSString *currentScoreString = [NSString stringWithFormat:@"%li", DataManager.currentScore];
    self.scoreLabel.text = currentScoreString;
    self.scoreLabelDropShadow.text = currentScoreString;
}

- (void)showScoreBoardAndHideScoreCounter {
    [self removeActionForKey:updateScoreActionKey];
    [self.scoreboard reloadData];
    [self hideScoreLabel];
    CGSize size = self.scene.view.frame.size;
    self.scoreboard.position = CGPointMake(size.width/2, size.height/2);
    self.gameState = scoreboard;
}

@end
