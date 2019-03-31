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

                      @"Inspiration is powerful. Find yours.",

                      @"Knowledge is power.",

                      @"Reach out to an old connection.",

                      @"Prune your plant to keep it beautiful.",

                      @"Help yourself by helping others.",

                      @"Find harmony wherever possible.",

                      @"You are not your temptations.\nFeed the good ones only.",

                      @"If at first you don’t succeed, try again.",

                      @"What are you chasing, and why?",

                      @"Hike the mountain of failure\nto reach success.",

                      @"Consider a new perspective.",

                      @"Forgive not for others, but for yourself.",

                      @"How do others see you?",
                      
                      @"Your brain is a muscle. It needs exercise.",
                      
                      @"Life is a journey. Not a destination.",
                      
                      @"Change is constant.\nIntention leads it.",
                      
                      @"What artificial limits are holding you back?",
                      
                      @"The past is a story we tell ourselves.",
                      
                      @"Ideas are fragile.\nNuture them. Help them grow.",
                      
                      @"Everyone has strengths.\nLearn and take advantage of yours.",
                      
                      @"The sun will always shine again."];

    float index = arc4random_uniform(tips.count);
    return [tips objectAtIndex:index];
}

@end
