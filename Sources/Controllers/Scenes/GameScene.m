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

// Views
@property MonkNode *monkNode;
@property SKSpriteNode *background, *clouds1, *clouds2;
@property SKLabelNode *scoreLabel, *scoreLabelDropShadow;
@property TipCloudNode *tipCloudNode;

/// The node that visually indicates the ceiling and floor boundaries to the user.
/// Note that this is only for visual purposes. It does not interact with
/// anything related to collisions.
@property SKSpriteNode *bondaryGraphicNode;

// Collision Edges
@property SKNode *ceilingEdge;
@property SKNode *floorEdge;

@property (nonatomic) ScoreBoard *scoreboard;
@property CreditsNode *creditsNode;

@property SoundController *soundController;

@end

// Category bitmasks - used for edges and collision detection
static const uint32_t monkCategory = 0x1;
static const uint32_t treeCategroy = 0x1 << 1;
static const uint32_t grassCategory = 0x1 << 2;

static const NSString *updateScoreActionKey = @"updateScoreTimer";

@implementation GameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        [self deviceSpecificSetupWithSize:size];
        [self setUpScoreboard];
        [self setUpAndShowTitleViews];
        [self addClouds];
        [self setUpCreditsNode];
        [self setUpTipCloudWithSize:size];

        // Set up sound controller
        self.soundController = [[SoundController alloc] initForScene:self];

        self.gameState = title;
        [self.soundController playMusic];
    }

    return self;
}

- (void) deviceSpecificSetupWithSize:(CGSize)size {
    [self addBackground:size];
    [self addMonk:size];
    [self addGrassEdge:size];
    [self addBranchEdge:size];
    self.physicsWorld.contactDelegate = self;
}

#pragma mark - Set Up Scene

/// Set up and add the cloud node to this scene.
/// @param size This size must be provided to correctly position this node.
- (void)setUpTipCloudWithSize:(CGSize)size {
    TipCloudNode *tipCloudNode = [TipCloudNode new];
    self.tipCloudNode = tipCloudNode;
    self.tipCloudNode.position = CGPointMake(size.width/2, size.height + 45);
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
    [self addChild:self.scoreboard];
}

- (void)addMonk:(CGSize)size {
    self.monkNode = [MonkNode new];
    self.monkNode.position = CGPointMake(size.width/2, size.height/2);
    self.monkNode.physicsBody.categoryBitMask = monkCategory;
    self.monkNode.physicsBody.contactTestBitMask = treeCategroy | grassCategory;
    [self addChild:self.monkNode];
}

- (void)addBackground:(CGSize)size {

    if (self.background != nil && self.bondaryGraphicNode != nil) {
        // Prevent setting up objects again.
        return;
    }

    // Set up background objects.
    self.background = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"backgroundiPad" : @"backgroundiPhone")];
    self.bondaryGraphicNode = [SKSpriteNode spriteNodeWithImageNamed:( DeviceManager.isTablet ? @"grassAndTreeiPad" : @"grassAndTreeiPhone")];
    self.background.position = CGPointMake(size.width/2, size.height/2);
    self.bondaryGraphicNode.position = CGPointMake(size.width/2, size.height/2);

    // Show background elements.
    [self addChild:self.background];
    [self addChild:self.bondaryGraphicNode];
}

- (void)addGrassEdge:(CGSize)size {

    self.ceilingEdge = [SKNode node];

    //Prepare image for 4 inch screen
    if (size.height == 568 && size.width == 320) {
        self.ceilingEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 126) toPoint:CGPointMake(size.width, 126)];
    }

    //Prepare edge for 3.5 inch screen
    if (size.width == 320 && size.height == 480) {
        float grassEdge = 49;
        self.ceilingEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, grassEdge) toPoint:CGPointMake(size.width, grassEdge)];
    }

    //Prepare for iPad
    if (size.width == 768 && size.height == 1024) {
        int grassEdgeLocation = 38;
        self.ceilingEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, grassEdgeLocation) toPoint:CGPointMake(size.width, grassEdgeLocation)];
    }

    self.ceilingEdge.physicsBody.dynamic = NO;
    self.ceilingEdge.physicsBody.categoryBitMask = grassCategory;

    [self addChild:self.ceilingEdge];
}

- (void) addBranchEdge:(CGSize) size {

    self.floorEdge = [SKNode node];

    //Prepare image for 4 inch screen
    if (size.height == 568 && size.width == 320) {
        self.floorEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, (size.height/20)*17) toPoint:CGPointMake(size.width, (size.height/20)*17)];
    }

    if (size.width == 320 && size.height == 480) {
        float branchEdge = 410;
        self.floorEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, branchEdge) toPoint:CGPointMake(size.width, branchEdge)];
    }

    //Prepare for iPad
    if (size.width == 768 && size.height == 1024) {
        self.floorEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, ((size.height/20) * 17)) toPoint:CGPointMake(size.width, (size.height/20)*17)];
    }

    self.floorEdge.physicsBody.dynamic = NO;
    self.floorEdge.physicsBody.categoryBitMask = treeCategroy;

    [self addChild:self.floorEdge];
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
    if (self.gameState != title) { return; }
    SKAction *fade = [SKAction fadeOutWithDuration:.25];
    SKAction *remove  = [SKAction removeFromParent];
    [self enumerateChildNodesWithName:@"startLabel" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[fade, remove]]];
    }];
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

    SKLabelNode *tapToStartLabel = [SKLabelNode new];
    tapToStartLabel.fontName = FontManager.appFontName;
    tapToStartLabel.text = @"tap to float";
    tapToStartLabel.name = @"startLabel";
    [tapToStartLabel setFontColor:SKColor.whiteColor];
    tapToStartLabel.fontSize = taptoStartFontSize;
    tapToStartLabel.position = CGPointMake(self.size.width/2, (DeviceManager.isTablet ? 100 : 90));

    SKLabelNode *tapToStartLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia Regular"];
//    SKLabelNode *tapToStartLabelDropShadow = [SKLabelNode new];
//    tapToStartLabelDropShadow.fontName = FontManager.appFontName;
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

- (void) showCredits {

    if (self.creditsNode == nil) {
        NSLog(@"CREDITS IS NIL");
    }

    self.creditsNode.position = CGPointMake(self.size.width/2, self.size.height *2);
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

    float DS = 3.7;
    if (self.size.height == 1024 && self.size.width == 768) { DS = DS + 10; }

    //set and run animation for actual label to hide
    [self.scoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, (self.size.height + 50)) duration:.5]];
    //set and run animation for dropshadow hide
    [self.scoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + DS, self.size.height + (50 + DS)) duration:.5]];
}

- (void)showTipCloud {
    SKAction *showAction = [SKAction moveTo:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 50) duration:0.25];
    [self.tipCloudNode runAction:showAction];
    [self.tipCloudNode reloadTip];
}

- (void)hideTipCloud {
    SKAction *hideAction = [SKAction moveTo:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height + 45) duration:0.25];
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

- (void)handleScoreboardInteractionForName:(NSString *)name {

    if ([name isEqual: @"replayButton"]) {
        [self replayButtonPressed];

    } else if ([name isEqual:@"gameCenterButton"]) {
        [self gameCenterButtonPressed];

    } else if ([name isEqual: @"creditsButton"]) {
        [self creditsButtonPressed];

    } else if ([name isEqualToString:facebookNodeId] || [name isEqualToString:twitterNodeId]) {
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

- (void)didBeginContact:(SKPhysicsContact*)contact {
    if (contact.bodyA.categoryBitMask == treeCategroy || contact.bodyB.categoryBitMask == treeCategroy) {
        [self touchedTree];
    } else if (contact.bodyA.categoryBitMask == grassCategory || contact.bodyB.categoryBitMask == grassCategory){
        [self touchedGrass];
    }
}

- (void)touchedTree {
    [self endGame];
}

- (void)touchedGrass {
    [self endGame];
}

// MARK: - Game Management

- (void)startGame {
    self.gameState = newGame;
    [self.scoreboard hideScore];
    [self hideTipCloud];
    [self.soundController playMusic];
}

/// Handles all behavior related to the end of a game.
- (void)endGame {

    if (self.gameState != playing) { return; }

    // Stop the timer.
    [self removeActionForKey:updateScoreActionKey];

    [self.monkNode openEyes];

    [self hideScoreLabel];

    [self.scoreboard reloadData];
    [self showScoreBoardAndHideScoreCounter];
    [self handleHighScore];

    DataManager.combinedScores += DataManager.currentScore;

    if (DataManager.currentScore >= 10) {
        [self showTipCloud];
    }

    [self.soundController stopMusic];
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
    [self.scoreboard showScore];
    self.gameState = scoreboard;
}

/// Updates the high score if necessary, and plays a sound based on score.
- (void)handleHighScore {
    if (DataManager.currentScore > DataManager.highScore) {
        DataManager.highScore = DataManager.currentScore;
        [self.soundController playHighScoreSound];
    } else {
        [self.soundController playGameOverSound];
    }
}

@end