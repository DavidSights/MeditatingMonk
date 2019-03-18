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

@property SKLabelNode *currentScoreLabel, *highScoreNumberLabel;

@end

@implementation ScoreBoard

-(id)init:(CGSize) size {
    self = [super init];
    
    self.size = size;
    
    if (!DeviceManager.isTablet) {
        // Set up for iPhone
        self.scoreInfo = [SKSpriteNode spriteNodeWithImageNamed:@"scoreboardiPhone"];
        self.replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"buttoniPhone"];
        self.gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"buttoniPhone"];
        self.twitterButton = [SKSpriteNode spriteNodeWithImageNamed:@"twitterButtoniPhone"];
        self.facebookButton = [SKSpriteNode spriteNodeWithImageNamed:@"facebookButtoniPhone"];
        self.replayIcon = [SKSpriteNode spriteNodeWithImageNamed:@"playIconiPhone"];
        self.gameCenterIcon = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenterIconiPhone"];
        self.scoreInfo.position = CGPointMake(0,50);
        self.replayButton.position = CGPointMake(-80, -110);
        self.gameCenterButton.position = CGPointMake(80, -110);
        self.twitterButton.position = CGPointMake(-70, -60);
        self.facebookButton.position = CGPointMake(70, -60);

    } else {
        // Set up for iPad
        self.scoreInfo = [SKSpriteNode spriteNodeWithImageNamed:@"scoreboardiPad"];
        self.replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"buttoniPad"];
        self.gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"buttoniPad"];
        self.twitterButton = [SKSpriteNode spriteNodeWithImageNamed:@"twitterButtoniPad"];
        self.facebookButton = [SKSpriteNode spriteNodeWithImageNamed:@"facebookButtoniPad"];
        self.replayIcon = [SKSpriteNode spriteNodeWithImageNamed:@"playIconiPad"];
        self.gameCenterIcon = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenterIconiPad"];
        self.scoreInfo.position = CGPointMake(0,50);
        self.replayButton.position = CGPointMake(-180, -290);
        self.gameCenterButton.position = CGPointMake(180, self.replayButton.position.y);
        self.twitterButton.position = CGPointMake(-160, -140);
        self.facebookButton.position = CGPointMake(160, -140);
    }
    
    self.replayButton.name = @"replayButton";
    self.gameCenterButton.name = @"gameCenterButton";
    self.twitterButton.name = @"twitterButton";
    self.facebookButton.name = @"facebookButton";
    self.replayIcon.name = @"replayButton";
    self.gameCenterIcon.name = @"gameCenterButton";

    self.position = CGPointMake(size.width/2, size.height * 2);
    
    [self addChild:self.scoreInfo];
    [self addChild:self.replayButton];
    [self addChild:self.gameCenterButton];

    [self.scoreInfo addChild:self.twitterButton];
    [self.scoreInfo addChild:self.facebookButton];
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
    [self.scoreInfo addChild:self.currentScoreLabel];
    
    SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    yourScoreLabel.fontColor = lightColor;
    yourScoreLabel.fontSize = 15;
    yourScoreLabel.position = CGPointMake(-70, 65);
    yourScoreLabel.text =@"Your Score";
    if (size.height == 1024 && size.width == 768) {
        yourScoreLabel.fontSize = 35;
        yourScoreLabel.position = CGPointMake(-160, 170);
    }
    [self.scoreInfo addChild:yourScoreLabel];
    
    self.highScoreNumberLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    self.highScoreNumberLabel.fontSize = 30;
    self.highScoreNumberLabel.fontColor = lightColor;
    self.highScoreNumberLabel.position = CGPointMake(70, 25);
    self.highScoreNumberLabel.text = @"0";

    if (size.height == 1024 && size.width == 768) {
        self.highScoreNumberLabel.fontSize = 70;
        self.highScoreNumberLabel.position = CGPointMake(160, 70);
    }

    [self.scoreInfo addChild:self.highScoreNumberLabel];
    
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    highScoreLabel.fontColor = lightColor;
    highScoreLabel.fontSize = 15;
    highScoreLabel.position = CGPointMake(70, 65);
    highScoreLabel.text =@"High Score";

    if (size.height == 1024 && size.width == 768) {
        highScoreLabel.position = CGPointMake(160, 170);
        highScoreLabel.fontSize = 35;
    }
    
    [self.scoreInfo addChild:highScoreLabel];
    
    SKLabelNode *shareLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    shareLabel.text = @"share you score";
    shareLabel.fontSize = 12;
    shareLabel.fontColor = lightColor;
    shareLabel.position = CGPointMake(0, -16);

    if (size.height == 1024 && size.width == 768) {
        shareLabel.fontSize = 25;
        shareLabel.position = CGPointMake(0, -35);
    }
    
    [self.scoreInfo addChild:shareLabel];

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

- (void) showScore:(int) currentScore {
    if (!DeviceManager.isTablet) {
        [self runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:.5]];
    } else {
        [self runAction:[SKAction moveTo:CGPointMake(self.size.width/2, (self.size.height/2) + 15) duration:.5]];
    }
    
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%i", currentScore];
    self.highScoreNumberLabel.text = [NSString stringWithFormat:@"%lli", self.highScore];
}

- (void) hideScore {
    [self runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height * 2) duration:.5]];
}



@end
