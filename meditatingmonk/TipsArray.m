//
//  TipsArray.m
//  meditatingmonk
//
//  Created by David Seitz Jr on 10/18/15.
//  Copyright © 2015 DavidSights. All rights reserved.
//

#import "TipsArray.h"

@implementation TipsArray

+ (NSString *)tip {

    NSArray *tips = @[@"Take a step towards your goal today.",

                      @"An end is also a beginning.",

                      @"Use simple thoughts to clear your mind.",

                      @"Fill your life with what inspires you.",

                      @"Knowledge is power.",

                      @"When communication exists, distance does not.",

                      @"Pruning leads to beauty.",

                      @"Helping others may help yourself.",

                      @"There is beauty in harmony.",

                      @"Not all temptations must be satisfied.",

                      @"If at first you don’t succeed, try again.",

                      @"Why do you want what you want?",

                      @"Happiness is a choice.",

                      @"Failure is the first step to success.",

                      @"Perspective helps one to see clearly.",

                      @"Forgiveness is a path to peace.",

                      @"How do others see you?",
                      
                      @"Brains, like muscles, should be exercised.",
                      
                      @"Explore more to learn more.",
                      
                      @"Life will take new forms over time.",
                      
                      @"Limits can be broken.",
                      
                      @"The past is a story we tell ourselves.",
                      
                      @"Ideas are seeds that want to grow.",
                      
                      @"Strength exists within us all.",
                      
                      @"What attachments are holding you back?"];

    float index = arc4random_uniform(tips.count - 1.0);
    return [tips objectAtIndex:index];
}

@end
