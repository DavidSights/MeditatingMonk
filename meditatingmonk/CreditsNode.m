//
//  CreditsNode.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 8/30/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "CreditsNode.h"

@interface CreditsNode()

@property BOOL iPhone, iPhone35, iPad;

@end

@implementation CreditsNode

-(id)init:(CGSize) size {
    self = [super init];

    self.size = size;

    self.iPhone = NO;
    self.iPhone35 = NO;
    self.iPad = NO;

    if (size.height == 568 && size.width == 320) {
        self.iPhone = YES;
    }

    if (size.width == 320 && size.height == 480) {
        self.iPhone35 = YES;
    }

    if (size.width == 768 && size.height == 1024) {
        self.iPad = YES;
    }

    self.name = @"CreditsNodes";

    // Matching colors for menu.

    SKColor *darkColor = [SKColor colorWithRed:(134.0/255.0)
                                         green:(114.0/255.0)
                                          blue:(58.0/255.0)
                                         alpha:1.0];

    SKColor *lightColor =[SKColor colorWithRed:(155.0/255.0)
                                         green:(136.0/255.0)
                                          blue:(72.0/255.0)
                                         alpha:1.0];
    NSString *backgroundImage;

    if (self.iPhone || self.iPhone35) {
        backgroundImage = @"creditsBackground02iPhone";
    } else if (self.iPad) {
        backgroundImage = @"creditsBackgroundiPad";
    }

    [self addChild:[SKSpriteNode spriteNodeWithImageNamed:backgroundImage]];

#warning Maybe all of these should get a new instance from a method?

    SKLabelNode *title =            [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKLabelNode *nameDavid =        [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKLabelNode *nameDavy =         [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKLabelNode *descriptionDavid = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKLabelNode *descriptionDavy =  [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKLabelNode *returnToGame =     [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];

    title.fontColor = lightColor;
    nameDavid.fontColor = darkColor;
    nameDavy.fontColor = darkColor;
    descriptionDavid.fontColor = lightColor;
    descriptionDavy.fontColor = lightColor;
    returnToGame.fontColor = [SKColor whiteColor];

    NSString *iconImage;

    if (self.iPhone || self.iPhone35) {
        iconImage = @"icon";
    } else if (_iPad) {
        iconImage = @"creditsIconiPad";
    }

    SKSpriteNode *icon = [SKSpriteNode spriteNodeWithImageNamed:iconImage];

    title.text = @"Meditating Monk was made by";

    //Title and icon position
    if (self.iPhone) {
        title.fontSize = 10;
        icon.position = CGPointMake(0, 220);
        title.position = CGPointMake(0, icon.position.y - 60);
    } else if (self.iPhone35) {
        title.fontSize = 10;
        int adj = -30;
        icon.position = CGPointMake(0, 220 + adj);
        title.position = CGPointMake(0, icon.position.y - 53);
    } else if (self.iPad) {
        title.fontSize = 20;
        int adj = 175;
        [icon setScale:.75];
        icon.position = CGPointMake(0, 220 + adj);
        title.position = CGPointMake(0, icon.position.y - 100);
    }

    [self addChild:icon];
    [self addChild:title];

    nameDavid.text = @"David Seitz Jr";
    nameDavy.text = @"Davy Wolf";
    descriptionDavid.text = @"Programmer, Designer, and Writer";

    descriptionDavy.text = @"Music and Sound Artist";

    NSString *emailButtonImage = [[NSString alloc] init];
    NSString *twitterButtonImage = [[NSString alloc] init];

    if (self.iPhone || self.iPhone35) {
        emailButtonImage = @"emailButtoniPhone";
        twitterButtonImage = @"twitterButton2iPhone";
    } else if (self.iPad) {
        emailButtonImage = @"emailButtoniPad";
        twitterButtonImage = @"twitterButton2iPad";
    }

    SKSpriteNode *davyTwitter = [SKSpriteNode spriteNodeWithImageNamed:twitterButtonImage];
    davyTwitter.name = @"davyTwitter";

    SKSpriteNode *davyEmail = [SKSpriteNode spriteNodeWithImageNamed:emailButtonImage];
    davyEmail.name = @"davyEmail";

    SKSpriteNode *davidTwitter = [SKSpriteNode spriteNodeWithImageNamed:twitterButtonImage];
    davidTwitter.name = @"davidTwitter";

    SKSpriteNode *davidEmail = [SKSpriteNode spriteNodeWithImageNamed:emailButtonImage];
    davidEmail.name = @"davidEmail";

    NSString *button;
    if (self.iPhone || self.iPhone35) {
        button = @"creditsButtonPressediPhone";
    } else if (self.iPad) {
        button = @"creditsButtonPressediPad";
    }

    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:button];
    SKLabelNode *backLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:button];
    SKLabelNode *rateLabel = [SKLabelNode labelNodeWithFontNamed:@"minecraftia"];

    backLabel.fontColor = darkColor;

    backLabel.text = @"Go Back";
    backLabel.name = @"goBack";

    backButton.name = @"goBack";

    rateLabel.fontColor = darkColor;

    rateLabel.text = @"Rate";
    rateLabel.name = @"rate";
    rateButton.name = @"rate";

    if (self.iPhone) {
        nameDavid.fontSize = 20;
        nameDavy.fontSize = 20;
        descriptionDavy.fontSize = 12;
        descriptionDavid.fontSize = 12;
        descriptionDavid.position = CGPointMake(-12, 80);
        nameDavid.position = CGPointMake(-50, 100);

        davyTwitter.position = CGPointMake(-110, -100);
        davyEmail.position = CGPointMake(davyTwitter.position.x + 80, davyTwitter.position.y);
        descriptionDavy.position = CGPointMake(-53, -60);
        nameDavy.position = CGPointMake(-80, -40);
        davidTwitter.position = CGPointMake(-110, 40);
        davidEmail.position = CGPointMake(davidTwitter.position.x + 80, davidTwitter.position.y);

        backLabel.fontSize = 12;
        backLabel.position = CGPointMake(0, -7);
        rateLabel.fontSize = 12;
        rateLabel.position = CGPointMake(0, -7);

        backButton.position = CGPointMake(-70, -190);
        rateButton.position = CGPointMake(70, -190);

    } else if (self.iPhone35) {
        nameDavid.fontSize = 20;
        nameDavy.fontSize = 20;
        descriptionDavy.fontSize = 12;
        descriptionDavid.fontSize = 12;
        descriptionDavid.position = CGPointMake(-12, 80);
        nameDavid.position = CGPointMake(-50, 100);

        int adj = -13;

        davyTwitter.position = CGPointMake(-110, -100 - adj);
        davyEmail.position = CGPointMake(davyTwitter.position.x + 80, davyTwitter.position.y);
        descriptionDavy.position = CGPointMake(-53, -60 -adj);
        nameDavy.position = CGPointMake(-80, -40 - adj);
        davidTwitter.position = CGPointMake(-110, 40);
        davidEmail.position = CGPointMake(davidTwitter.position.x + 80, davidTwitter.position.y);

        backLabel.fontSize = 12;
        backLabel.position = CGPointMake(0, -7);
        rateLabel.fontSize = 12;
        rateLabel.position = CGPointMake(0, -7);

        backButton.position = CGPointMake(-70, -155);
        rateButton.position = CGPointMake(70, backButton.position.y);

    } else if (self.iPad) {

        int nameFS = 40;
        int descFS = 25;
        int adj = 0;

        nameDavid.fontSize = nameFS;
        nameDavy.fontSize = nameFS;
        descriptionDavy.fontSize = descFS;
        descriptionDavid.fontSize = descFS;

        nameDavid.position = CGPointMake(-150, 175);
        descriptionDavid.position = CGPointMake(-62, 140);
        nameDavy.position = CGPointMake(-215, -80);
        descriptionDavy.position = CGPointMake(-155, -115 -adj);

        [davidTwitter setScale:.75];
        [davidEmail setScale:.75];
        [davyTwitter setScale:.75];
        [davyEmail setScale:.75];

        davidTwitter.position = CGPointMake(-280, descriptionDavid.position.y - 75);
        davidEmail.position = CGPointMake(davidTwitter.position.x + 135, davidTwitter.position.y);
        davyTwitter.position = CGPointMake(davidTwitter.position.x, descriptionDavy.position.y - 75);
        davyEmail.position = CGPointMake(davidEmail.position.x, davyTwitter.position.y - adj);

        backLabel.fontSize = 24;
        backLabel.position = CGPointMake(0, -14);
        rateLabel.fontSize = backLabel.fontSize;
        rateLabel.position = CGPointMake(0, backLabel.position.y);

        backButton.position = CGPointMake(-170, -340);
        rateButton.position = CGPointMake(-backButton.position.x, backButton.position.y);
    }

    [self addChild:nameDavid];
    [self addChild:descriptionDavid];
    [self addChild:nameDavy];
    [self addChild:descriptionDavy];
    [self addChild:davyTwitter];
    [self addChild:davyEmail];
    [self addChild:davidTwitter];
    [self addChild:davidEmail];

    [backButton addChild:backLabel];
    [rateButton addChild:rateLabel];
    
    [self addChild:backButton];
    [self addChild:rateButton];
    
    return self;
}

@end
