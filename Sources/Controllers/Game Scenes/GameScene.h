//
//  MyScene.h
//  MeditatingMonk
//
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@protocol GameSceneDelegate <NSObject>

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)shareScore:(NSString *)score;

@end

@interface GameScene : SKScene

@property (weak, nonatomic) id<GameSceneDelegate> gameSceneDelegate;

@end
