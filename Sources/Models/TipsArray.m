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

    NSArray *tips = @[@"Take a step towards a life goal today.",

                      @"Every end is a new beginning.",

                      @"Think of puppies. And kitties. And feel good.",

                      @"What inspires you? Fit more of that into your life.",

                      @"Knowledge is power.",

                      @"Reach out to an old connection.",

                      @"Prune your plant to keep it beautiful.",

                      @"Help yourself by helping others.",

                      @"Find harmony wherever possible.",

                      @"You are not your temptations. Feed the good ones only.",

                      @"If at first you don’t succeed, try again.",

                      @"What are you chasing, and why?",

                      @"Happiness is a moving target. Pick a still one and happiness will follow.",

                      @"Success is the peak of a mountain called failure. Climb it.",

                      @"Consider a new perspective.",

                      @"Forgiving others will do more for you than them.",

                      @"How do others see you?",
                      
                      @"Your brain is a muscle. It needs exercise.",
                      
                      @"Life is a journey. Not a destination.",
                      
                      @"Are you the same person you were a year ago? A decade ago?",
                      
                      @"What artificial limits are holding you back?",
                      
                      @"The past is a story we tell ourselves.",
                      
                      @"Ideas are fragile. Nuture them. Help them grow.",
                      
                      @"Everyone has strengths. Learn and take advantage of yours.",
                      
                      @"The sun will always shine again."];

    float index = arc4random_uniform(tips.count);
    return [tips objectAtIndex:index];
}

@end
