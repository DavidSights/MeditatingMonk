//
//  TipCloud.m
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/18/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import "TipCloud.h"
#import "TipsArray.h"
#import "MeditatingMonk-Swift.h"

@implementation TipCloud

- (void)positionWithFrame:(CGRect)frame
{
    if (frame.size.width < 600) {
        [self loadForiPhone];
        self.position = CGPointMake(frame.size.width/2,frame.size.height - 45);
    } else {
        [self loadForiPad];
        self.position = CGPointMake(frame.size.width/2,frame.size.height - 98);
    }
    self.name = @"tip";
    [self fadeIn];
}

- (void)loadForiPhone {

    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"tipCloudiPhone"];
    [self addChild:background];
    [self addChild:[self tipLabelWithFontSize:10]];
}

- (void)loadForiPad {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"tipCloudiPad"];
    [self addChild:background];
    [self addChild:[self tipLabelWithFontSize:20]];
}

- (SKLabelNode *)tipLabelWithFontSize:(int)fontSize {

    SKLabelNode *tipLabel = [[SKLabelNode alloc] init];
    tipLabel.fontColor = [SKColor colorWithRed:111.0/255.0 green:158.0/255.0 blue:183.0/255.0 alpha:1.0];
    tipLabel.position = CGPointMake(0, -5);
    tipLabel.fontName = FontManager.appFontName;
    tipLabel.text = [TipsArray tip];
    tipLabel.fontSize = fontSize;

    return tipLabel;
}

- (void)fadeIn {

    self.alpha = 0;

    SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];

    [self runAction:fadeIn];
}

@end
