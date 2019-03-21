//
//  menu.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 7/22/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "ScoreBoard.h"
#import "MeditatingMonk-Swift.h"

@interface ScoreBoard()

/// The container view for everything displayed in this scoreboard.
@property SKSpriteNode *scoreBoardView;

// Labels

@property SKLabelNode *currentScoreLabel;
@property SKLabelNode *highScoreValueLabel;

// Buttons

@property SKSpriteNode *replayButton;
@property SKSpriteNode *gameCenterButton;
@property SKSpriteNode *twitterButton;
@property SKSpriteNode *facebookButton;

// Icons

@property SKSpriteNode *replayIcon;
@property SKSpriteNode *gameCenterIcon;

@end

@implementation ScoreBoard

- (id)init:(CGSize)size {
    self = [super init];
    [self initializeSubviews];
    
    [self addChild:self.scoreBoardView];
    [self addChild:self.replayButton];
    [self addChild:self.gameCenterButton];

    [self.scoreBoardView addChild:self.twitterButton];
    [self.scoreBoardView addChild:self.facebookButton];
    [self.replayButton addChild:self.replayIcon];
    [self.gameCenterButton addChild:self.gameCenterIcon];
    
    //Colors to be used for menu
    SKColor *darkColor = [SKColor colorWithRed:(134.0/255.0) green:(114.0/255.0) blue:(58.0/255.0) alpha:1.0];
    SKColor *lightColor =[SKColor colorWithRed:(155.0/255.0) green:(136.0/255.0) blue:(72.0/255.0) alpha:1.0];
    
    self.currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.currentScoreLabel.fontSize = 30;
    //lesson learned for color - the .0 matters, RGB needs to be divided by 255 to have a value between 0 and 1.
    self.currentScoreLabel.fontColor = darkColor;
    self.currentScoreLabel.position = CGPointMake(-70, 25);
    if (size.height == 1024 && size.width == 768) {
        self.currentScoreLabel.fontSize = 70;
        self.currentScoreLabel.position = CGPointMake(-160, 70);
    }
    [self.scoreBoardView addChild:self.currentScoreLabel];
    
    SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    yourScoreLabel.fontColor = lightColor;
    yourScoreLabel.fontSize = 15;
    yourScoreLabel.position = CGPointMake(-70, 65);
    yourScoreLabel.text =@"Your Score";
    if (size.height == 1024 && size.width == 768) {
        yourScoreLabel.fontSize = 35;
        yourScoreLabel.position = CGPointMake(-160, 170);
    }
    [self.scoreBoardView addChild:yourScoreLabel];
    
    self.highScoreValueLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.highScoreValueLabel.fontSize = 30;
    self.highScoreValueLabel.fontColor = lightColor;
    self.highScoreValueLabel.position = CGPointMake(70, 25);
    self.highScoreValueLabel.text = @"0";

    if (size.height == 1024 && size.width == 768) {
        self.highScoreValueLabel.fontSize = 70;
        self.highScoreValueLabel.position = CGPointMake(160, 70);
    }

    [self.scoreBoardView addChild:self.highScoreValueLabel];
    
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    highScoreLabel.fontColor = lightColor;
    highScoreLabel.fontSize = 15;
    highScoreLabel.position = CGPointMake(70, 65);
    highScoreLabel.text =@"High Score";

    if (size.height == 1024 && size.width == 768) {
        highScoreLabel.position = CGPointMake(160, 170);
        highScoreLabel.fontSize = 35;
    }
    
    [self.scoreBoardView addChild:highScoreLabel];
    
    SKLabelNode *shareLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    shareLabel.text = @"share your score";
    shareLabel.fontSize = 12;
    shareLabel.fontColor = lightColor;
    shareLabel.position = CGPointMake(0, -16);

    if (size.height == 1024 && size.width == 768) {
        shareLabel.fontSize = 25;
        shareLabel.position = CGPointMake(0, -35);
    }
    
    [self.scoreBoardView addChild:shareLabel];

    SKSpriteNode *creditsButton = [SKSpriteNode new];

    if (!DeviceManager.isTablet) {
        creditsButton = [SKSpriteNode spriteNodeWithImageNamed:@"creditsButtoniPhone"];
    } else {
        creditsButton = [SKSpriteNode spriteNodeWithImageNamed:@"creditsButtoniPad"];
    }

    creditsButton.name = @"creditsButton";
    SKLabelNode *creditsButtonText = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    
    creditsButtonText.fontColor = lightColor;
    creditsButtonText.text = @"Credits";

    creditsButtonText.name = @"creditsButton";
    
    if (!DeviceManager.isTablet) {
        creditsButton.position = CGPointMake(0, -185);
        creditsButtonText.fontSize = 12;
        creditsButtonText.position = CGPointMake(0, -4);
    } else {
        creditsButtonText.fontSize = 25;
        [creditsButton setScale:0.85];
        creditsButton.position = CGPointMake(0, -415);
        creditsButtonText.position = CGPointMake(0, -8);
    }
    
    [creditsButton addChild:creditsButtonText];
    [self addChild:creditsButton];
    
    return self;
}

- (void)initializeSubviews {

    // Set up the container view.

    self.scoreBoardView = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"scoreboardiPad" : @"scoreboardiPhone")
                                         identifierName:nil
                                              positionX:0
                                              positionY:50];
    // Set up the buttons.

    self.replayButton = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"buttoniPad" : @"buttoniPhone")
                                       identifierName:@"replayButton"
                                            positionX:-80
                                            positionY:(DeviceManager.isTablet ? -290 : -110)];


    self.gameCenterButton = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"buttoniPad" : @"buttoniPhone")
                                           identifierName:@"gameCenterButton"
                                                positionX:self.replayButton.position.x*-1
                                                positionY:self.replayButton.position.y];

    self.twitterButton = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"twitterButtoniPad" : @"twitterButtoniPhone")
                                        identifierName:@"twitterButton"
                                             positionX:-70
                                             positionY:(DeviceManager.isTablet ? -140 : -60)];

    self.facebookButton = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"facebookButtoniPad" : @"facebookButtoniPhone")
                                         identifierName:@"facebookButton"
                                              positionX:70
                                              positionY:self.twitterButton.position.y];
    // Set up the icons.

    self.replayIcon = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"playIconiPad" : @"playIconiPhone")
                                     identifierName:@"replayButton"
                                          positionX:0
                                          positionY:0];

    self.gameCenterIcon = [self imageSpriteWithFileName:(DeviceManager.isTablet ? @"gameCenterIconiPad" : @"gameCenterIconiPhone")
                                         identifierName:@"gameCenterButton"
                                              positionX:0
                                              positionY:0];
}

- (void)showScore:(int)currentScore {
    
    // Move the scoreboard into its viewable position.
    CGSize size = self.scene.view.frame.size;
    int xPosition = size.width / 2;
    int yPosition = (DeviceManager.isTablet ? ((size.height/2) + 15) : size.height/2);
    [self runAction:[SKAction moveTo:CGPointMake(xPosition, yPosition) duration:.5]];

    // Update the scoreboard's content.
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%i", currentScore];
    self.highScoreValueLabel.text = [NSString stringWithFormat:@"%lli", self.highScore];
}

- (void) hideScore {
    CGSize size = self.scene.view.frame.size;
    [self runAction:[SKAction moveTo:CGPointMake(size.width/2, size.height * 2) duration:.5]];
}

- (SKSpriteNode *)imageSpriteWithFileName:(NSString *)fileName identifierName:(NSString *)identifierName positionX:(int)x positionY:(int)y {
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:fileName];
    image.position = CGPointMake(x, y);
    image.name = identifierName;
    return image;
}

- (void)reloadData {
    self.highScoreValueLabel.text = [NSString stringWithFormat:@"%li", (long)DataManager.highScore];
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%i", DataManager.currentScore];
}

@end
