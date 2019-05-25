//
//  CreditsNode.m
//  MeditatingMonk
//
//  Created by David Seitz Jr on 8/30/14.
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import "CreditsNode.h"
#import "MeditatingMonk-Swift.h"

@interface CreditsNode ()

@end

@implementation CreditsNode

- (id)init:(CGSize)size {
    self = [super init];

    self.name = @"CreditsNode";

    [self addChild:[SKSpriteNode spriteNodeWithImageNamed:@"creditsBackground02iPhone"]];

    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    title.text = @"Meditating Monk was made by";
    title.fontColor = UIColor.creditsLight;
    [self addChild:title];

    SKLabelNode *nameDavid = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    nameDavid.fontColor = UIColor.creditsDark;

    SKLabelNode *nameDavy = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    nameDavy.fontColor = UIColor.creditsDark;

    SKLabelNode *descriptionDavid = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    descriptionDavid.fontColor = UIColor.creditsLight;

    SKLabelNode *descriptionDavy = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    descriptionDavy.fontColor = UIColor.creditsLight;

    SKLabelNode *returnToGame = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    returnToGame.fontColor = [SKColor whiteColor];

    SKSpriteNode *icon = [SKSpriteNode spriteNodeWithImageNamed:DeviceManager.isTablet ? @"creditsIconiPad" : @"icon"];

    //Title and icon position
    if (!DeviceManager.isTablet) {
        title.fontSize = 10;
        icon.position = CGPointMake(0, 220);
        title.position = CGPointMake(0, icon.position.y - 60);
    } else {
        title.fontSize = 20;
        int adj = 175;
        [icon setScale:.75];
        icon.position = CGPointMake(0, 220 + adj);
        title.position = CGPointMake(0, icon.position.y - 100);
    }

    [self addChild:icon];

    nameDavid.text = @"David Seitz Jr";
    nameDavy.text = @"Davy Wolf";
    descriptionDavid.text = @"Programmer, Designer, and Writer";

    descriptionDavy.text = @"Music and Sound Artist";

    NSString *emailButtonImage = [[NSString alloc] init];
    NSString *twitterButtonImage = [[NSString alloc] init];

    if (!DeviceManager.isTablet) {
        emailButtonImage = @"emailButtoniPhone";
        twitterButtonImage = @"twitterButton2iPhone";
    } else {
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
    if (!DeviceManager.isTablet) {
        button = @"creditsButtonPressediPhone";
    } else {
        button = @"creditsButtonPressediPad";
    }

    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:button];
    SKLabelNode *backLabel = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:button];
    SKLabelNode *rateLabel = [SKLabelNode labelNodeWithFontNamed:FontManager.appFontName];

    backLabel.fontColor = UIColor.creditsDark;

    backLabel.text = @"Go Back";
    backLabel.name = @"goBack";

    backButton.name = @"goBack";

    rateLabel.fontColor = UIColor.creditsDark;

    rateLabel.text = @"Rate";
    rateLabel.name = @"rate";
    rateButton.name = @"rate";

    if (!DeviceManager.isTablet) {
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

    } else {

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
