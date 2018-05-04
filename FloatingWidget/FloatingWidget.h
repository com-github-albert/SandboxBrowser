//
//  FloatingWidget.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingPresentationModeDelegate.h"

@class FloatingWidgetViewController;

@interface FloatingWidget : NSObject <FloatingPresentationModeDelegate>

/**
 Presentation mode for Floating. It currently supports three presentation modes.
 It can be a small floating button, that we can keep around, or a full window for actual
 profiling, or it can simply be disabled.
 */
@property (nonatomic, assign) FloatingPresentationMode presentationMode;
@property (nonatomic, assign, getter=isEnabled, readonly) BOOL enabled;
@property (nonatomic, assign, getter=isAutoHideEnabled) BOOL autoHideEnabled;

/**
 UI
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) FloatingWidgetViewController *mainViewController;
@property (nonatomic, assign) CGSize mainViewControllerSize;

/**
 It will show a button that after clicking will bring up the memory profiler.
 */
- (void)enable;

/**
 The window will be destroyed.
 */
- (void)disable;

@end
