//
//  FloatingWidgetViewController.m
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "FloatingWidgetViewController.h"

@implementation FloatingWidgetViewController

- (void)containerWillMove:(UIViewController *)container {
    // No extra behavior
}

- (BOOL)shouldStretchInMovableContainer {
    return YES;
}

- (CGFloat)minimumHeightInMovableContainer {
    return 0;
}

@end
