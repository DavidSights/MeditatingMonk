//
//  MyScene.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/13/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "GameScene.h"
#import <GameKit/GameKit.h>
#import "Sounds.h"
#import "TipCloud.h"

@interface GameScene ()

// Flags
@property (nonatomic) BOOL playGame, ignoreTouches, scoreShown, timerStarted, monkHitSomething, gameStarted, gameFinished, iPhone, iPhone35, iPad, musicPlaying, creditsShowing, firstHop;

// Views
@property SKSpriteNode *monkNode, *background, *grassAndTree, *clouds1, *clouds2, *tipBackground;
@property SKLabelNode *currentScoreLabel, *currentScoreLabelDropShadow;

// Actions
@property SKAction *openEyes, *closeEyes;
@property SKNode *grassEdge, *branchEdge;

// Score
@property (nonatomic) int startLabelCount, currentScore, totalTaps, combinedScores, resetCount;
@property (nonatomic) long long highScore;

@property (nonatomic) NSArray *loadedAchievements;
@property (nonatomic) GKScore *retrievedScore;

@property (strong, nonatomic) SLComposeViewController *SLComposeVC;
@property CGVector floatUp;

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@property (nonatomic) ScoreBoard *myMenu;
@property CreditsNode *credits;

@property (nonatomic) ViewController *myVC;
@property UIViewController *myUIVC;

@property (nonatomic) NSUserDefaults *userDefaults;

@property Sounds* sounds;

@end

// Category bitmasks - used for edges and collision detection
static const uint32_t monkCategory = 0x1;
static const uint32_t treeCategroy = 0x1 << 1;
static const uint32_t grassCategory = 0x1 << 2;

@implementation GameScene

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.userDefaults = [NSUserDefaults standardUserDefaults];

        [self initialFlagsSetup];

        [self deviceSpecificSetupWithSize:size];

        [self setupScoreBoard:size]; // Needs to be called after device size has been determined.

        [self showStartOption];

        [self hideiAd];

        [self addClouds];

        [self loadAchievements];

        [self setUpMusic];

        [self setupCredits];

        [self setupPhysics];

        self.sounds = [Sounds new];
        [self addChild:self.sounds];
    }

    return self;
}

- (void)setupPhysics {

    // World and monk physics
    float floatAlt = 1;

    if (self.iPhone || self.iPhone35) {
        float dAlt = 1.1;
        self.physicsWorld.gravity = CGVectorMake(0, -8);
        self.floatUp = CGVectorMake(0, 1100 * floatAlt);
        self.monkNode.physicsBody.density = self.monkNode.physicsBody.density * dAlt;
    }

    if (self.iPad) {
        NSLog(@"monk densitiy = %f", self.monkNode.physicsBody.density);
        self.physicsWorld.gravity = CGVectorMake(0, -15);
        self.floatUp = CGVectorMake(0, 1200 * floatAlt);
        self.monkNode.physicsBody.density = .1;
    }
}

- (void) setupCredits {

    CGSize size = self.view.frame.size;

    self.credits = [[CreditsNode alloc] init:size];
    self.credits.position = CGPointMake(size.width/2, size.height/2);
    self.credits.name = @"credits node view";
    self.creditsShowing = NO;
}

- (void) loadAchievements {

    //Load achievements
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {

        if (error == nil) {
            self.loadedAchievements = achievements;
        } else {
            NSLog(@"MyScene, -handleAchievements: There was an error while loading achievements: %@", error);
        }
    }];
}

- (void)setupScoreBoard:(CGSize)size {

    int scoreLabelFontSize = self.iPad ? 60 : 30;

    // Create score label - moved here because it was laggy during the first click to begin the game.
    self.currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.currentScoreLabel.text = @"0";
    self.currentScoreLabel.fontSize = scoreLabelFontSize;
    [self.currentScoreLabel setFontColor:[SKColor whiteColor]];
    self.currentScoreLabel.name = @"currentScoreLabel";
    self.currentScoreLabel.position = CGPointMake(size.width/2, (self.size.height/10) * 11);

    // Drop shadow text
    self.currentScoreLabelDropShadow = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.currentScoreLabelDropShadow.text = @"0";
    self.currentScoreLabelDropShadow.fontSize = scoreLabelFontSize;
    [self.currentScoreLabelDropShadow setFontColor:[SKColor blackColor]];
    self.currentScoreLabelDropShadow.name = @"currentScoreLabelDropShadow";
    self.currentScoreLabelDropShadow.position = CGPointMake(self.currentScoreLabel.position.x, self.currentScoreLabel.position.y);

    // Prepare score to be added.
    self.myMenu = [[ScoreBoard alloc] init:size];
    [self addChild:self.myMenu];

    self.gameStarted = NO;

    // Create score label with drop shadow. Add drop shadow first so it's behind the actual label.
    [self addChild:self.currentScoreLabelDropShadow];
    [self addChild:self.currentScoreLabel];

    self.combinedScores = (int)[self.userDefaults integerForKey:@"combinedScores"];
    self.totalTaps = (int)[self.userDefaults integerForKey:@"totalTaps"];
}

- (void) initialFlagsSetup {

    self.playGame = NO;
    self.firstHop = NO;
    self.scoreShown = NO;
    self.ignoreTouches = NO;
    self.monkHitSomething = NO;
}

- (void) deviceSpecificSetupWithSize:(CGSize)size {

    self.iPhone = NO;
    self.iPhone35 = NO;
    self.iPad = NO;

    if (size.height == 568 && size.width == 320) {self.iPhone = YES;}
    if (size.width == 320 && size.height == 480) {self.iPhone35 = YES;}
    if (size.width == 768 && size.height == 1024) {self.iPad = YES;}

    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

    [self addBackground:size];
    [self addMonk:size];
    [self addGrassEdge:size];
    [self addBranchEdge:size];

    self.physicsWorld.contactDelegate = self;

    //4 inch screen
    if ((size.height == 568 && size.width == 320) || (size.width == 320 && size.height == 480)) {
        self.openEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monkAwake@2x" ofType:@"png" ]]];
        self.closeEyes = [SKAction setTexture:[SKTexture textureWithImageNamed:[[NSBundle mainBundle] pathForResource:@"monk@2x" ofType:@"png"]]];
    }

    //iPad
    if (size.width == 768 && size.height == 1024) {
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
    }
    else {
        self.musicPlayer.numberOfLoops = -1;
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }

    self.musicPlaying = YES;
}

- (void) stopMusic {
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

- (void) addBackground:(CGSize)size {

    NSLog(@"MyScene, -addBackground: Device size = %f x %f", size.width, size.height);

    //Prepare image for 4 inch screen
    if (size.height == 568 && size.width == 320) {
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiPhone"];
        self.grassAndTree = [SKSpriteNode spriteNodeWithImageNamed:@"grassAndTreeiPhone"];
        self.background.position = CGPointMake(size.width/2, size.height/2);
        self.grassAndTree.position = CGPointMake(size.width/2, size.height/2);
    }

    //Prepare image for 3.5 inch screen
    if (size.width == 320 && size.height == 480) {
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiPhone"];
        self.grassAndTree = [SKSpriteNode spriteNodeWithImageNamed:@"grassAndTreeiPhone"];
        int offset = 33;
        self.background.position = CGPointMake(size.width/2, (size.height/2) - offset);
        self.grassAndTree.position = CGPointMake(size.width/2, (size.height/2) - offset);
    }

    //Prepare for iPad
    if (size.width == 768 && size.height == 1024) {
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiPad"];
        self.grassAndTree = [SKSpriteNode spriteNodeWithImageNamed:@"grassAndTreeiPad"];
        self.background.position = CGPointMake(size.width/2, size.height/2);
        self.grassAndTree.position = CGPointMake(size.width/2, size.height/2);
    }

    if (self.background != nil) {
        [self addChild:self.background];
        [self addChild:self.grassAndTree];
    } else {
        NSLog(@"MyScene, -addBackground: Error: No background image detected.");
    }
}

- (void) addGrassEdge:(CGSize)size {

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

- (void) setupClouds
{
    NSString *cloudsImage1;
    NSString *cloudsImage2;

    if (self.iPhone || self.iPhone35) {
        cloudsImage1 = @"clouds1";
        cloudsImage2 = @"clouds2";
    } else if (self.iPad) {
        cloudsImage1 = @"clouds1iPad";
        cloudsImage2 = @"clouds2iPad";
    }

    self.clouds1 = [SKSpriteNode spriteNodeWithImageNamed:cloudsImage1];
    self.clouds2 = [SKSpriteNode spriteNodeWithImageNamed:cloudsImage2];
    self.clouds1.anchorPoint = CGPointMake(0, 0.5);
    self.clouds2.anchorPoint = CGPointMake(0, 0.5);
    self.clouds1.position = CGPointMake(self.size.width, 80);
    self.clouds2.position = CGPointMake(self.size.width, 80);
}

- (void) addClouds {
    [self setupClouds];
    CGPoint cloudDestination = CGPointMake((0 -(self.size.width/2)) - (self.clouds1.size.width),100);
    CGPoint cloudStart = CGPointMake(self.size.width, 100);
    SKAction *moveClouds = [SKAction moveTo:cloudDestination duration:20];
    SKAction *returnClouds = [SKAction moveTo:cloudStart duration:0];
    [self.background addChild:self.clouds1];
    [self.background addChild:self.clouds2];
    [self.clouds1 runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveClouds, returnClouds]]]];
    [self.clouds2 runAction:[SKAction sequence:@[[SKAction waitForDuration:10],[SKAction repeatActionForever:[SKAction sequence:@[moveClouds, returnClouds]]]]]];
}

- (void) resetMonkHit {
    self.monkHitSomething = NO;
    NSLog(@"Monk can hit things and cause actions again.");
}

#pragma mark - Grpahics and Animations

- (void)startLabelFadeAwayIfNcessary {

    if (self.gameStarted == NO) {

        SKAction *fade = [SKAction fadeOutWithDuration:.25];
        SKAction *remove  = [SKAction removeFromParent];

        [self enumerateChildNodesWithName:@"startLabel" usingBlock:^(SKNode *node, BOOL *stop) {
            [node runAction:[SKAction sequence:@[fade, remove]]];
        }];
    }
}

- (void) showStartOption {

    for (SKNode* node in self.children) {

        if ([node.name isEqualToString:@"startLabel"]) {
            self.startLabelCount++;
        }
    }

    if (self.startLabelCount < 1) {
        SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"title"];

        if (_iPhone) {
            title.position = CGPointMake(self.size.width/2, 440);
        } else if (_iPhone35) {
            title.position = CGPointMake(self.size.width/2, 400);
        } else if (_iPad) {
            title = [SKSpriteNode spriteNodeWithImageNamed:@"titleiPad"];
            title.position = CGPointMake(self.size.width/2, 800);
        }

        title.name = @"startLabel";

        SKLabelNode * tapToStart = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
        SKLabelNode *directions = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
        SKLabelNode * tapToStartDS = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
        SKLabelNode *directionsDS = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
        [directions setFontColor:[SKColor whiteColor]];
        [tapToStart setFontColor:[SKColor whiteColor]];
        [directionsDS setFontColor:[SKColor blackColor]];
        [tapToStartDS setFontColor:[SKColor blackColor]];
        tapToStart.name = @"startLabel";
        directions.name = @"startLabel";
        tapToStartDS.name = @"startLabel";
        directionsDS.name = @"startLabel";

        if (self.iPhone || self.iPhone35) {
            int tap = 20;
            int dir = 14;
            tapToStart.fontSize = tap;
            directions.fontSize = dir;
            tapToStartDS.fontSize = tap;
            directionsDS.fontSize = dir;
        }

        float DS1 = 2.5;
        float DS2 = 2;

        tapToStart.text = @"tap to float";
        directions.text = @"don't hit the tree or ground";
        tapToStartDS.text = tapToStart.text;
        directionsDS.text = directions.text;

        if (_iPhone || _iPhone35) {
            tapToStart.position = CGPointMake(self.size.width/2, 90);
            directions.position = CGPointMake(self.size.width/2, tapToStart.position.y - 20);
            tapToStartDS.position = CGPointMake(tapToStart.position.x + DS1, tapToStart.position.y - DS1);
            directionsDS.position = CGPointMake(directions.position.x + DS2, directions.position.y - DS2);
        } else if (_iPad) {
            DS1 = 3.8;
            DS2 = 3.8;
            tapToStart.position = CGPointMake(self.size.width/2, 100);
            directions.position = CGPointMake(self.size.width/2, tapToStart.position.y - 50);
            tapToStartDS.position = CGPointMake(tapToStart.position.x + DS1, tapToStart.position.y - DS1);
            directionsDS.position = CGPointMake(directions.position.x + DS2, directions.position.y - DS2);
        }

        [self addChild:title];
        [self addChild:tapToStartDS];
        [self addChild:directionsDS];
        [self addChild:tapToStart];
        [self addChild:directions];

        SKAction *off = [SKAction fadeOutWithDuration:0];
        SKAction *on = [SKAction fadeInWithDuration:0];
        SKAction *blink = [SKAction repeatActionForever:[SKAction sequence:@[off, [SKAction waitForDuration:.35], on, [SKAction waitForDuration:.5]]]];
        [tapToStart runAction:blink];
        [tapToStartDS runAction:blink];
        [directions runAction:blink];
        [directionsDS runAction:blink];
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

-(void) showCurrentScore{
    float DS = 3.7;
    if (self.size.height == 1024 && self.size.width == 768) { DS = DS + 3.9; }

    //Reset the score to show a new score counter.
    self.currentScoreLabel.text=@"0";
    self.currentScoreLabelDropShadow.text = @"0";
    self.currentScore = 0;

    int currentScoreLabelPosition = (self.size.height - 50);

    if (self.size.width == 320 && self.size.height == 480) {
        currentScoreLabelPosition = self.size.height - 47;
    }

    if ( self.size.height == 1024 && self.size.width == 768 ) {currentScoreLabelPosition = self.size.height - 80;}

    //set and run animation for actual label to enter
    [self.currentScoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, currentScoreLabelPosition) duration:.5]];
    //set and run animation for dropshadow label
    [self.currentScoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + DS, (currentScoreLabelPosition - DS)) duration:.5]];

    self.scoreShown = YES;

    [self resetMonkHit]; // Called here temporarily to find a good place for reseting monk hit flag.
}

-(void) hideCurrentScore {

    float DS = 3.7;
    if (self.size.height == 1024 && self.size.width == 768) { DS = DS + 10; }

    //Before hiding the current score, save the counted score to the currentScore int.
    self.currentScore = [self.currentScoreLabel.text intValue];

    //set and run animation for actual label to hide
    [self.currentScoreLabel runAction:[SKAction moveTo:CGPointMake(self.size.width/2, (self.size.height + 50)) duration:.5]];
    //set and run animation for dropshadow hide
    [self.currentScoreLabelDropShadow runAction:[SKAction moveTo:CGPointMake(self.size.width/2 + DS, self.size.height + (50 + DS)) duration:.5]];
    self.scoreShown = NO;
}

- (void)showiAd {
    //Show iAd
    NSLog(@"Showing ad from contacting grass.");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showsBanner" object:self];
}

- (void) hideiAd {
    //Hide iAd
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hidesBanner" object:self];
}

- (void)showTip {
    if (self.currentScore >= 10) {
        TipCloud *tip = [TipCloud new];
        [tip positionWithFrame:self.frame];
        [self addChild:tip];
        NSLog(@"Tip shown.");
    } else {
        NSLog(@"Tip not shown due to low score.");
    }
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

- (void)createAndPerformChanceBasedImpulse {

    CGVector OGFloatUp = self.floatUp;

    int weakChance = arc4random()%9;

    weakChance++;

    if (weakChance == 10 || weakChance == 1) {
        float floatAlt = .8;
        self.floatUp = CGVectorMake(0, self.floatUp.dy * floatAlt);
    } else if (weakChance == 5) {

        if (_firstHop == YES) {
            float floatAlt = 1.1;
            self.floatUp = CGVectorMake(0, self.floatUp.dy * floatAlt);
        }

    } else if (weakChance == 2 || weakChance == 9) {
        float floatAlt = .9;
        self.floatUp = CGVectorMake(0, self.floatUp.dy * floatAlt);
    }

    [self.monkNode.physicsBody applyImpulse:self.floatUp];

    self.floatUp = OGFloatUp;

    if (self.firstHop == NO) {
        self.firstHop = YES;
    }

}

-(void)startTimer {

    if (self.timerStarted == NO) {

        self.timerStarted = YES;

        [self runAction: [SKAction repeatActionForever:
                          [SKAction sequence:@[
                                               [SKAction waitForDuration:1],
                                               [SKAction performSelector:@selector(incrementScore) onTarget:self]
                                               ]
                           ]] withKey:@"timer"];
    }
}

- (void)showScore {
    if (self.scoreShown == NO) {
        [self showCurrentScore];
        self.scoreShown = YES;
    }
}

#pragma mark - Interaction

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self startLabelFadeAwayIfNcessary];

    if (self.ignoreTouches == NO) {

        if (self.playGame == YES) {

            // Monk actions

            [self createAndPerformChanceBasedImpulse];

            [self.sounds playJumpSound];

            [self.monkNode runAction:self.closeEyes];

            // Timer/Score actions

            self.startLabelCount = 0;

            [self startTimer];

            [self showScore];

            self.totalTaps++;

        } else {
            self.resetCount++;
            if (_resetCount >= 30) {
                _resetCount = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Secret Reset Option" message:@"You tapped 30 times after a game. Would you like to reset your score?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            };
        }

        NSString *name = [[NSString alloc] init];
        for (UITouch *touch in touches) {
            //Only check for buttons pressed in menu node if the credits node isn't showing
            if (self.creditsShowing == NO) {

                //Set up for checking for buttons in menu node
                SKNode *touchedElement = [self.myMenu nodeAtPoint:[touch locationInNode:self.myMenu]];
                name = touchedElement.name;

                if ([name isEqual: @"replayButton"]) {
                    [self.myMenu hideScore];
                    self.playGame = YES;
                    //Hide iAd
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"hidesBanner" object:self];
                    [self hideTip];
                    if (self.musicPlaying == NO) {
                        [self.musicPlayer play];
                        self.musicPlaying = YES;
                        self.resetCount = 0;
                    }
                }

                if ([name isEqual:@"gameCenterButton"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showGameCenter" object:self];
                    [self.sounds playButtonSound];
                }

                if ([name isEqual:@"twitterButton"] && self.creditsShowing == NO) {

                    [self.sounds playButtonSound];

                    NSLog(@"Twitter button pressed.");

                    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                        self.SLComposeVC = [[SLComposeViewController alloc] init];
                        self.SLComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

                        NSString *shareText = [[NSString alloc] initWithFormat:@"Just scored %i! Can you beat my score? #MonkGame https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8", self.currentScore];

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
                if ([name isEqual:@"facebookButton"] && self.creditsShowing == NO) {

                    [self.sounds playButtonSound];

                    // Share to facebook
                    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                        self.SLComposeVC = [[SLComposeViewController alloc] init];
                        self.SLComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

                        NSString *shareText = [[NSString alloc] initWithFormat:@"Just scored %i! Can you beat my score? #MonkGame https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8", self.currentScore];

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
                if ([name isEqual: @"creditsButton"] && self.creditsShowing == NO) {

                    [self.sounds playButtonSound];

                    [self showCredits];
                    _resetCount = 0;
                }
            }

            //If credits are showing, check for any buttons pressed within the credits node.
            if (self.creditsShowing == YES) {
                for (UITouch *touch in touches) {

                    SKNode *touchedElement = [self.credits nodeAtPoint:[touch locationInNode:self.credits]];
                    name = touchedElement.name;

                    if ([name isEqual:@"davidTwitter"]) {

                        [self.sounds playButtonSound];

                        NSLog(@"David twitter button pressed");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/davidsights"]];
                    }

                    if ([name isEqual:@"davyTwitter"]) {

                        [self.sounds playButtonSound];
                        NSLog(@"davy twitter button pressed");
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/davywolfmusic"]];
                    }

                    if ([name isEqual:@"goBack"]) {

                        [self.sounds playButtonSound];

                        [self hideCredits];
                        self.resetCount = 0;
                    }

                    if ([name isEqual:@"rate"]) {

                        [self.sounds playButtonSound];

                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/meditating-monk/id904463280?ls=1&mt=8"]];
                    }

                    if ([name isEqual:@"davidEmail"]) {
                        [self.sounds playButtonSound];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"emailDavid" object:self];
                    }
                    if ([name isEqual:@"davyEmail"]) {
                        [self.sounds playButtonSound];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"emailDavy" object:self];
                    }
                }
            }
        }

        if (self.gameStarted == NO) {
            // Allows dismissal of UI that appears when app is launched.
            self.gameStarted = YES;
            self.playGame = YES;
        }
    }
}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Yes"]){
        [self resetHighScores];
        self.resetCount = 0;
    } else if ([title isEqualToString:@"No"]) {
        self.resetCount = 0;
        NSLog(@"MyScene -alertView: Scores were not reset.");
    }
}

- (void)stopTouches {
    self.ignoreTouches = YES;
    SKAction *wait = [SKAction sequence:@[[SKAction waitForDuration:.5],[SKAction performSelector:@selector(stopIgnoringTouches) onTarget:self]]];
    [self runAction:wait];
}

- (void) stopIgnoringTouches {
    self.ignoreTouches = NO;
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

- (void) touchedTree {
    NSLog(@"Monk hit tree.");

    //Show iAd
    NSLog(@"Showing banner from contacting tree.");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showsBanner" object:self];

    [self.monkNode runAction:self.openEyes];
    self.playGame = NO;
    [self stopTouches];
    //Stop incrementScore method
    [self removeActionForKey:@"timer"];
    self.timerStarted = NO;

    //Set the highscore
    if (self.currentScore > self.highScore) {
        self.highScore = self.currentScore;
        self.myMenu.highScore = self.highScore;
        [self.userDefaults setInteger:(int)self.highScore forKey:@"monkGameHighScore"];
        [self.userDefaults synchronize];
        [self reportScore:self.highScore forLeaderboardID:@"highScoreLB"];
        [self.sounds playHighScoreSound];
    }
    else {
        [self.sounds playGameOverSound];
    }

    if (self.gameStarted == YES) {
        NSLog(@"Showing scoreboard and hiding score counter.");
        self.myMenu.score = self.currentScore;
        [self.myMenu showScore:self.currentScore];
        [self hideCurrentScore];
    }

    [self updateCombinedScores];
    [self updateTotalTaps];

    //Prevent simultaneous actions after game ends.
    self.monkHitSomething = YES;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1], [SKAction performSelector:@selector(resetMonkHit) onTarget:self]]]];

    [self handleAchievements];

    [self showTip];

    [self.musicPlayer stop];
    self.musicPlayer.currentTime = 0;
    self.musicPlaying = NO;
    self.firstHop = NO;
}

- (void) touchedGrass {

    if (self.monkHitSomething == NO) {

        NSLog(@"Monk hit the grass. Stopping game.");

        [self.monkNode runAction:self.openEyes];

        self.playGame = NO;

        [self stopTouches];

        self.timerStarted = NO;

        if (self.gameStarted == YES) {

            [self showiAd];
            [self showTip];
            [self determineHighScore];
            [self stopMusic];
            [self showScoreBoardAndHideScoreCounter];

            self.firstHop = NO;
        }

        self.monkHitSomething = YES; // Prevent simultaneous actions after game ends.

        //        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1], [SKAction performSelector:@selector(resetMonkHit) onTarget:self]]]];

        [self handleAchievements];
        [self updateCombinedScores];
        [self updateTotalTaps];

    } else {
        NSLog(@"Monk hit grass again. No actions necessary.");
    }
}

#pragma mark - Score

- (void) incrementScore {
    self.currentScore++;
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", self.currentScore];
    self.currentScoreLabelDropShadow.text = [NSString stringWithFormat:@"%d", self.currentScore];
}

- (void) loadHighScore {
    self.myMenu.highScore = [self.userDefaults integerForKey:@"monkGameHighScore"];
    self.highScore = [self.userDefaults integerForKey:@"monkGameHighScore"];
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs:@[player.playerID]];
    leaderboardRequest.identifier = @"highScoreLB";
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        self.retrievedScore = scores.firstObject;
        NSLog(@"RETRIEVED SCORE: %lld", self.retrievedScore.value);
        if (self.retrievedScore != nil) {
            NSLog(@"MyScene: Retrieved high score: %lld", self.retrievedScore.value);

            //Check if Game Center score is higher, and if so, load it into the game's userDefaults
            if (self.retrievedScore.value > [self.userDefaults integerForKey:@"monkGameHighScore"]) {

                NSLog(@"MyScene: Updating scores to match Game Center scores. Initial scores - UserDefaults: %ld  self.highScore: %lld  self.myMenu.highScore: %lld",
                      (long)[self.userDefaults integerForKey:@"monkGameHighScore"], self.highScore, self.myMenu.highScore);

                self.myMenu.highScore = self.retrievedScore.value;
                self.highScore = self.retrievedScore.value;
                [self.userDefaults setInteger:(int)self.retrievedScore.value forKey:@"monkGameHighScore"];

                NSLog(@"MyScene: Updated scores - UserDefaults: %ld  self.highScore: %lld  self.myMenu.highScore: %lld",
                      (long)[self.userDefaults integerForKey:@"monkGameHighScore"], self.highScore, self.myMenu.highScore);

                NSLog(@"Would have updated userDefaults high score to match Game Center high score, but did not.");
            }
            else {
                NSLog(@"MyScene: Retrieved GC score is not higher than saved score. Loading saved userDefaults score.");
                self.myMenu.highScore = [self.userDefaults integerForKey:@"monkGameHighScore"];
                self.highScore = [self.userDefaults integerForKey:@"monkGameHighScore"];
            }
        }
        else {
            NSLog(@"MyScene: -loadHighScore failed to load high score from Game Center. self.retrievedScore == nil.");
            //No score was found, continue using UserDefaults recorded score.
        }

        if (error != nil) {
            NSLog(@"MyScene: Error while loading high score: %@", error);
        }

    }];
}

- (void) resetHighScores {
    NSLog(@"resetHighScores called");
    [self.userDefaults setInteger:0 forKey:@"monkGameHighScore"];
    self.highScore = 0;
    self.myMenu.score = 0;
    self.myMenu.highScore = 0;
    //    self.myMenu.currentScoreLabel = 0;
    //    self.myMenu.highScoreNumberLabel = 0;
    [self reportScore:1 forLeaderboardID:@"highScoreLB"]; //Cannot reset Game Center high score... so this won't work.
}

- (void) determineHighScore {
    //Set the highscore
    if (self.currentScore > self.highScore) {
        self.highScore = self.currentScore;
        self.myMenu.highScore = self.highScore;
        [self.userDefaults setInteger:(int)self.highScore forKey:@"monkGameHighScore"];
        [self.userDefaults synchronize];
        [self reportScore:self.highScore forLeaderboardID:@"highScoreLB"];
        [self.sounds playHighScoreSound];
    }
    else {
        [self.sounds playGameOverSound];
    }
}

- (void) showScoreBoardAndHideScoreCounter {
    NSLog(@"Showing scoreboard and hiding score counter.");

    [self removeActionForKey:@"timer"]; //Stop incrementScore method

    self.myMenu.score = self.currentScore;
    [self.myMenu showScore:self.currentScore];

    [self hideCurrentScore];
}

#pragma mark - Game Center

- (void)handleAchievements {

    if (self.currentScore >= 10) {
        NSString *achievementID = @"score10";
        BOOL earned = NO;
        BOOL ranThroughLoop = NO;
        for (GKAchievement *achievement in self.loadedAchievements) {
            if ([achievement.identifier  isEqual: achievementID]) {earned = YES;}
            if (!earned){ NSLog(@"Score 10 achievement not earned yet.");
                //report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;
                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (!error) {NSLog(@"Achievement for %@ reported", achievementID);}
                    else {NSLog(@"Error reporting achievement: %@", error);}
                }];
            }
            ranThroughLoop = YES;
        }

        if (!ranThroughLoop) {
            //Didn't run through loop because nothing is stored in achievements - report achievement for score10, placing the first object into achievements.
            GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
            achievement.percentComplete = 100;
            [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                if (!error) {NSLog(@"Achievement for %@ reported", achievementID);}
                else {NSLog(@"Error reporting achievement: %@", error);}
            }];
            //reload self.achievements for safe measure, to make sure something is in there the next time around!
            [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
                if (error == nil) {self.loadedAchievements = achievements;}
                else {NSLog(@"MyScene, -handleAchievements: There was an error while loading achievements: %@", error);}
            }];
        }
    }

    if (self.currentScore >= 25) {
        NSString *achievementID = @"score25";
        BOOL earned = NO;
        for (GKAchievement *achievement in self.loadedAchievements) {
            if ([achievement.identifier  isEqual: achievementID]) {earned = YES;}
            if (!earned){
                //report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;
                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (!error) {NSLog(@"Achievement for %@ reported", achievementID);}
                    else {NSLog(@"Error reporting achievement: %@", error);}
                }];
            }
        }
    }

    if (self.currentScore >= 50) {

        NSString *achievementID = @"score50";

        BOOL earned = NO;

        for (GKAchievement *achievement in self.loadedAchievements) {
            if ([achievement.identifier  isEqual: achievementID]) {
                earned = YES;
            }

            if (!earned) {

                //Report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;

                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (!error) {
                        NSLog(@"Achievement for %@ reported", achievementID);
                    } else {
                        NSLog(@"Error reporting achievement: %@", error);
                    }
                }];
            }
        }
    }

    if (self.currentScore >= 100) {

        NSString *achievementID = @"score100";

        BOOL earned = NO;

        for (GKAchievement *achievement in self.loadedAchievements) {

            if ([achievement.identifier  isEqual: achievementID]) {
                earned = YES;
            }

            if (!earned){

                // Report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;

                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (!error) {
                        NSLog(@"Achievement for %@ reported", achievementID);
                    }
                    else {
                        NSLog(@"Error reporting achievement: %@", error);
                    }
                }];
            }
        }
    }

    if (self.currentScore >= 150) {

        NSString *achievementID = @"score150";

        BOOL earned = NO;

        for (GKAchievement *achievement in self.loadedAchievements) {
            if ([achievement.identifier  isEqual: achievementID]) {
                earned = YES;
            }

            if (!earned) {

                // Report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;

                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {

                    if (!error) {
                        NSLog(@"Achievement for %@ reported", achievementID);
                    } else {
                        NSLog(@"Error reporting achievement: %@", error);
                    }
                }];
            }
        }
    }

    if (self.currentScore >= 250) {

        NSString *achievementID = @"score250";

        BOOL earned = NO;

        for (GKAchievement *achievement in self.loadedAchievements) {

            if ([achievement.identifier  isEqual: achievementID]) {
                earned = YES;
            }

            if (!earned){

                // Report achievement for score10
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;

                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {

                    if (!error) {
                        NSLog(@"Achievement for %@ reported", achievementID);
                    } else {
                        NSLog(@"Error reporting achievement: %@", error);
                    }
                }];
            }
        }
    }

    if (self.currentScore >= 500) {

        NSString *achievementID = @"score500";

        BOOL earned = NO;

        for (GKAchievement *achievement in self.loadedAchievements) {

            if ([achievement.identifier  isEqual: achievementID]) {
                earned = YES;
            }

            if (!earned){
                GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:achievementID];
                achievement.percentComplete = 100;
                [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
                    if (!error) {NSLog(@"Achievement for %@ reported", achievementID);}
                    else {NSLog(@"Error reporting achievement: %@", error);}
                }];
            }
        }
    }
}

- (void) reportScore: (int64_t)score forLeaderboardID: (NSString*) leaderboardID {
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"MyScene: An error occured while reporting score.");
        }
        else {
            NSLog(@"Score reported as %lld", score);
        }
    }];
}

- (void)updateTotalTaps {
    
    [self.userDefaults setInteger:self.totalTaps forKey:@"totalTaps"];
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"focusLB"];
    score.value = self.totalTaps;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (!error) {
            NSLog(@"MyScene, -updateTotalTaps: Updated total taps.");
        }
        else {
            NSLog(@"MyScene, -updateTotalTaps: Error updating totalTaps: %@", error);
        }
    }];
}

- (void) updateCombinedScores {
    
    self.combinedScores = self.combinedScores + self.currentScore;
    
    [self.userDefaults setInteger:self.combinedScores forKey:@"combinedScores"];
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"perseveranceLB"];
    score.value = self.combinedScores;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        
        if (!error) {
            NSLog(@"MyScene, -updateCombinedScores: update combined scores successful");
        } else {
            NSLog(@"MyScene, -updateCombinedScores: There was an error while updating combined scores: %@", error);
        }
    }];
}

@end
