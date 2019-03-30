//
//  MyScene.h
//  MeditatingMonk
//
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

@protocol GameSceneDelegate <NSObject>

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

@interface GameScene : SKScene

@property (weak, nonatomic) id<GameSceneDelegate> gameSceneDelegate;

@end
