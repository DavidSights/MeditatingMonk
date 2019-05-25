//
//  MyScene.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <StoreKit/StoreKit.h>
#import "MeditatingMonk-Swift.h"
#import "GameScene.h"
#import "ScoreBoard.h"
#import "CreditsNode.h"

enum GameState {
    title,
    newGame,
    playing,
    scoreboard,
    credits
};

@interface GameScene () <SKPhysicsContactDelegate>

@property enum GameState gameState;
@property id<StageType> stage;
@property MonkNode *monkNode;
@property TipCloudNode *tipCloudNode;
@property ScoreBoard *scoreboard;
@property CreditsNode *creditsNode;
@property SoundController *soundController;

// Animated Clouds
@property SKSpriteNode *clouds1;
@property SKSpriteNode *clouds2;

// The incrementing score label.
@property SKLabelNode *scoreLabel;
@property SKLabelNode *scoreLabelDropShadow;

@end

@implementation GameScene {
    NSString *updateScoreActionKey;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        updateScoreActionKey = @"updateScoreTimer";

        // Set up sound controller
        self.soundController = [[SoundController alloc] initForScene:self];
        [self.soundController playMusic];

        self.physicsWorld.contactDelegate = self;
        self.gameState = title;
    }

    return self;
}

#pragma mark - Set Up Scene

- (void)setUpWithStage:(id<StageType>)stage {
    self.stage = stage;
    [self addChild:self.stage.node];

    CGSize size = UIScreen.mainScreen.bounds.size;
    [self addMonk:size];
    [self setUpTipCloudWithSize:size];

    [self setUpAndShowTitleViews];
    [self setUpScoreboard];
    [self setUpCreditsNode];
}

/// Set up and add the cloud node to this scene.
/// @param size This size must be provided to correctly position this node.
- (void)setUpTipCloudWithSize:(CGSize)size {
    TipCloudNode *tipCloudNode = [TipCloudNode new];
    self.tipCloudNode = tipCloudNode;
    self.tipCloudNode.position = CGPointMake(size.width/2, size.height + (DeviceManager.isTablet ? 90 : 45));
    [self addChild:tipCloudNode];
}

- (void)setUpCreditsNode {
    CGSize size = self.view.frame.size;
    self.creditsNode = [[CreditsNode alloc] init:size];
    self.creditsNode.position = CGPointMake(size.width/2, size.height/2);
}

- (void)setUpScoreboard {

    int scoreLabelFontSize = DeviceManager.isTablet ? 60 : 30;
    CGPoint scoreLabelPosition = CGPointMake(self.size.width / 2, self.size.height + 10);

    // Set up score label drop shadow. There has to be a better way to do this.
    self.scoreLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    self.scoreLabelDropShadow.text = @"0";
    self.scoreLabelDropShadow.fontSize = scoreLabelFontSize;
    [self.scoreLabelDropShadow setFontColor:[SKColor blackColor]];
    self.scoreLabelDropShadow.name = @"currentScoreLabelDropShadow";
    self.scoreLabelDropShadow.position = scoreLabelPosition;
    [self addChild:self.scoreLabelDropShadow];

    // Set up score label
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    self.scoreLabel.text = @"0";
    self.scoreLabel.fontSize = scoreLabelFontSize;
    [self.scoreLabel setFontColor:[SKColor whiteColor]];
    self.scoreLabel.name = @"currentScoreLabel";
    self.scoreLabel.position = scoreLabelPosition;
    [self addChild:self.scoreLabel];

    // Set up scoreboard.
    self.scoreboard = [[ScoreBoard alloc] init:self.size];
    self.scoreboard.position = CGPointMake(self.size.width/2, self.size.height * 2);
}

- (void)addMonk:(CGSize)size {
    self.monkNode = [MonkNode new];
    self.monkNode.position = CGPointMake(size.width/2, size.height/2);
    self.monkNode.physicsBody.categoryBitMask = BitMaskAccessor.playerBoundary;
    self.monkNode.physicsBody.contactTestBitMask = BitMaskAccessor.upperBoundary | BitMaskAccessor.lowerBoundary;
    [self addChild:self.monkNode];
}

// MARK: - Game Management

- (void)startGame {
    self.gameState = newGame;
    [self hideScoreboard];
    [self hideTipCloud];
    [self.soundController playMusic];
}

/// Handles all behavior related to the end of a game.
- (void)endGame {

    if (self.gameState != playing) { return; }

    [self.soundController stopMusic];
    [self.monkNode openEyes];
    [self hideScoreLabel];
    [self showScoreboard];
    [self updateHighScoreIfNecessary];

    DataManager.combinedScores += DataManager.currentScore;

    if (DataManager.currentScore >= 10) {
        [self showTipCloud];
    }
}

#pragma mark - Grpahics and Animations

- (void)hideTitleLabels {
    if (self.gameState != title) { return; }
    SKAction *fade = [SKAction fadeOutWithDuration:.25];
    SKAction *remove  = [SKAction removeFromParent];
    [self enumerateChildNodesWithName:@"startLabel" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[fade, remove]]];
    }];
}

- (void)setUpAndShowTitleViews {

    int taptoStartFontSize = DeviceManager.isTablet ? 40 : 20;
    int directionsFontSize = DeviceManager.isTablet ? 28 : 14;
    float dropShadowDistance = DeviceManager.isTablet ? 5 : 2.5;
    float dropShadowDistance2 = DeviceManager.isTablet ? 5 : 2;

    // Set up the title.
    SKSpriteNode *titleImageNode = [SKSpriteNode spriteNodeWithImageNamed: (!DeviceManager.isTablet ? @"title" : @"titleiPad")];
    titleImageNode.position = CGPointMake(self.size.width/2, (!DeviceManager.isTablet ? 440 : 800));
    titleImageNode.name = @"startLabel";
    [self addChild:titleImageNode];

    // Note: Drop shadows are being created here by creating a second label
    // to serve as the drop shadown, which is positioned just beneath its corresponding label.

    // Set up labels.

    SKLabelNode *tapToStartLabel = [SKLabelNode new];
    tapToStartLabel.fontName = FontManager.appFontName;
    tapToStartLabel.text = @"tap to float";
    tapToStartLabel.name = @"startLabel";
    [tapToStartLabel setFontColor:SKColor.whiteColor];
    tapToStartLabel.fontSize = taptoStartFontSize;
    tapToStartLabel.position = CGPointMake(self.size.width/2, (DeviceManager.isTablet ? 100 : 90));

    SKLabelNode *tapToStartLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia Regular"];
    tapToStartLabelDropShadow.text = tapToStartLabel.text;
    tapToStartLabelDropShadow.name = @"startLabel";
    [tapToStartLabelDropShadow setFontColor:SKColor.blackColor];
    tapToStartLabelDropShadow.fontSize = taptoStartFontSize;
    tapToStartLabelDropShadow.position = CGPointMake(tapToStartLabel.position.x + dropShadowDistance, tapToStartLabel.position.y - dropShadowDistance);
    [self addChild:tapToStartLabelDropShadow];
    [self addChild:tapToStartLabel];

    SKLabelNode *directionsLabel = [SKLabelNode new];
    directionsLabel.fontName = FontManager.appFontName;
    directionsLabel.text = @"don't hit the tree or ground";
    directionsLabel.name = @"startLabel";
    [directionsLabel setFontColor:SKColor.whiteColor];
    directionsLabel.fontSize = directionsFontSize;
    directionsLabel.position = CGPointMake(self.size.width/2, tapToStartLabel.position.y - (DeviceManager.isTablet ? 50 : 20));

    SKLabelNode *directionsLabelDropShadow = [SKLabelNode new];
    directionsLabelDropShadow.fontName = FontManager.appFontName;
    directionsLabelDropShadow.text = directionsLabel.text;
    directionsLabelDropShadow.name = @"startLabel";
    [directionsLabelDropShadow setFontColor:SKColor.blackColor];
    directionsLabelDropShadow.fontSize = directionsFontSize;
    directionsLabelDropShadow.position = CGPointMake(directionsLabel.position.x + dropShadowDistance2, directionsLabel.position.y - dropShadowDistance2);
    [self addChild:directionsLabelDropShadow];
    [self addChild:directionsLabel];

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

- (void)showCredits {
    self.creditsNode.position = CGPointMake(self.size.width/2, self.size.height*2);
    self.creditsNode.alpha = 0;
    [self addChild:self.creditsNode];
    [self.creditsNode runAction:[SKAction fadeInWithDuration:.4]];
    [self.creditsNode runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.3]];
}

- (void)hideCredits {
    [self.creditsNode runAction:[SKAction fadeOutWithDuration:.15] completion:^{
        [self.creditsNode removeFromParent];
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
}

- (void)hideScoreLabel {
    [self removeActionForKey:updateScoreActionKey];

    float DS = 3.7;
    if (self.size.height == 1024 && self.size.width == 768) { DS = DS + 10; }

    //set and run animation for actual label to hide
    [self.scoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, (self.size.height + 50)) duration:.5]];
    //set and run animation for dropshadow hide
    [self.scoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + DS, self.size.height + (50 + DS)) duration:.5]];
}

- (void)showTipCloud {
    SKAction *showAction = [SKAction moveTo:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - (DeviceManager.isTablet ? 100 : 50)) duration:0.25];
    [self.tipCloudNode runAction:showAction];
    [self.tipCloudNode reloadTip];
}

- (void)hideTipCloud {
    SKAction *hideAction = [SKAction moveTo:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + (DeviceManager.isTablet ? 90 : 45)) duration:0.25];
    [self.tipCloudNode runAction:hideAction];
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
    [self.soundController playJumpSound];
    [self.monkNode closeEyes];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.gameState == title) {
        [self hideTitleLabels];
        self.gameState = newGame;
        return;

    } else if (self.gameState == playing || self.gameState == newGame) {
        [self triggerGameAction];
        return;
    }

    for (UITouch *touch in touches) {

        if (self.gameState == scoreboard) {
            NSString *name = [[self.scoreboard nodeAtPoint:[touch locationInNode:self.scoreboard]] name];
            [self handleScoreboardInteractionForName:name];
            return;

        } else if (self.gameState == credits) {
            NSString *name = [[self.creditsNode nodeAtPoint:[touch locationInNode:self.creditsNode]] name];
            [self handleCreditsScreenInteractionForName:name];
            return;
        }
    }
}

// MARK: - Scoreboard

- (void)showScoreboard {
    [self.scoreboard reloadData];
    [self addChild:self.scoreboard];
    CGSize size = self.view.frame.size;
    SKAction *showAction = [SKAction moveTo:CGPointMake(size.width/2, size.height/2) duration:.5];
    [self.scoreboard runAction:showAction];
    self.gameState = scoreboard;
}

- (void)hideScoreboard {
    CGSize size = self.view.frame.size;
    SKAction *hideAction = [SKAction moveTo:CGPointMake(size.width/2, size.height*2) duration:.5];
    [self.scoreboard runAction:hideAction completion:^{
        [self removeChildrenInArray:@[self.scoreboard]];
    }];
}

- (void)handleScoreboardInteractionForName:(NSString *)name {

    if ([name isEqual: NodeID.replayButton]) {
        [self replayButtonPressed];

    } else if ([name isEqual:@"gameCenterButton"]) {
        [self gameCenterButtonPressed];

    } else if ([name isEqual: @"creditsButton"]) {
        [self creditsButtonPressed];

    } else if ([name isEqualToString:NodeID.facebookButton] || [name isEqualToString:NodeID.twitterButton]) {
        [self shareButtonPressed];
    }
}

- (void)replayButtonPressed {
    [self startGame];
}

- (void)gameCenterButtonPressed {
    [self.soundController playButtonSound];
    [self.gameSceneDelegate showAlertWithTitle:@"GameCenter Disabled"
                                       message:@"Sorry. GameCenter is temporarily disabled. This feature will be fixed or removed in a future version."];
}

- (void)creditsButtonPressed {
    [self.soundController playButtonSound];
    [self showCredits];
    self.gameState = credits;
}

- (void)shareButtonPressed {
    [self.soundController playButtonSound];
    NSString *currentScoreString = [NSString stringWithFormat:@"%li", DataManager.currentScore];
    [self.gameSceneDelegate shareScore:currentScoreString];
}

// MARK: - Credits Screen

- (void)handleCreditsScreenInteractionForName:(NSString *)name {

    if ([name isEqual:@"davidTwitter"]) {
        [self.soundController playButtonSound];
        NSURL *davidTwitter = [NSURL URLWithString:@"http://twitter.com/davidsights"];
        [UIApplication.sharedApplication openURL:davidTwitter options:@{} completionHandler:nil];

    } else if ([name isEqual:@"davyTwitter"]) {
        [self.soundController playButtonSound];
        [self.gameSceneDelegate showAlertWithTitle:@"Twitter Disabled" message:@"This Twitter account was disabled."];

    } else if ([name isEqual:@"goBack"]) {
        [self dismissCreditsButtonPressed];
        self.gameState = scoreboard;

    } else if ([name isEqual:@"rate"]) {
        [self rateButtonPressed];

    } else if ([name isEqual:@"davidEmail"]) {
        [self.soundController playButtonSound];
        [EmailManager sendEmailToName:EmailManager.david message:@""];

    } else if ([name isEqual:@"davyEmail"]) {
        [self.soundController playButtonSound];
        [EmailManager sendEmailToName:EmailManager.wolf message:@""];
    }
}

- (void)rateButtonPressed {
    [self.soundController playButtonSound];
    [SKStoreReviewController requestReview];
}

- (void)dismissCreditsButtonPressed {
    [self.soundController playButtonSound];
    [self hideCredits];
    self.gameState = scoreboard;
}

#pragma mark - Collisions

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == BitMaskAccessor.upperBoundary || contact.bodyB.categoryBitMask == BitMaskAccessor.upperBoundary) {
        [self endGame];
    } else if (contact.bodyA.categoryBitMask == BitMaskAccessor.lowerBoundary || contact.bodyB.categoryBitMask == BitMaskAccessor.lowerBoundary) {
        [self endGame];
    }
}

#pragma mark - Score

- (void)incrementScore {
    DataManager.currentScore = DataManager.currentScore + 1;
    NSString *currentScoreString = [NSString stringWithFormat:@"%li", DataManager.currentScore];
    self.scoreLabel.text = currentScoreString;
    self.scoreLabelDropShadow.text = currentScoreString;
}

/// Updates the high score if necessary, and plays a sound based on score.
- (void)updateHighScoreIfNecessary {
    if (DataManager.currentScore > DataManager.highScore) {
        DataManager.highScore = DataManager.currentScore;
        [self.soundController playHighScoreSound];
    } else {
        [self.soundController playGameOverSound];
    }
}

@end
