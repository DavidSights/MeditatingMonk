//
//  MyScene.h
//  MeditatingMonk
//
//  Copyright (c) 2014 DavidSights. All rights reserved.
//

@protocol GameSceneDelegate
- (void)showScoreResetOption;
@end

@interface GameScene : SKScene

@property (weak) id<GameSceneDelegate> gameSceneDelegate;

@end
