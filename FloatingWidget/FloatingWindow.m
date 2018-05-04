//
//  FloatingWindow.m
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "FloatingWindow.h"

@implementation FloatingWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        /**
         Window level will determine how on top we want to appear in window hierarchy.
         We do not want to hide alerts, but we want to be pretty much above everything else.
         */
        self.windowLevel = UIWindowLevelStatusBar + 100;
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_touchesDelegate window:self shouldReceiveTouchAtPoint:point]) {
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}

@end
