//
//  ViewController.h
//  MeditatingMonk
//

//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MessageUI.h>
#import "MeditatingMonk-Swift.h"

@interface ViewController : UIViewController <ADBannerViewDelegate, GKGameCenterControllerDelegate , MFMailComposeViewControllerDelegate>

@property GKLocalPlayer *localPlayer;

-(void)showAd;
-(void)hideAd;

@end
