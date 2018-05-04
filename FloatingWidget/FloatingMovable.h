//
//  FloatingMovable.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FloatingMovable <NSObject>

/**
 Container will move view controller (either by pan or pinch).
 */
- (void)containerWillMove:(nonnull UIViewController *)container;

/**
 Should view should stretch on pinch?
 */
- (BOOL)shouldStretchInMovableContainer;

/**
 @return minimum height that view controllers must have
 */
- (CGFloat)minimumHeightInMovableContainer;

@end
