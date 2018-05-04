//
//  FloatingWindow.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloatingWindowTouchedHandling <NSObject>

- (BOOL)window:(nullable UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point;

@end

@interface FloatingWindow : UIWindow

@property (nonatomic, weak, nullable) id<FloatingWindowTouchedHandling> touchesDelegate;

@end
