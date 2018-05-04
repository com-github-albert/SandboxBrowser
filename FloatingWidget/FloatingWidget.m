//
//  FloatingWidget.m
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "FloatingWidget.h"
#import "FloatingWindow.h"
#import "FloatingMenuController.h"
#import "FloatingContainerViewController.h"

static const float kFloatingMenuSize = 52.0;
static const float kFloatingMainSizeHeight = 300.0;

@interface FloatingWidget () <FloatingWindowTouchedHandling>
@end

@implementation FloatingWidget {
    FloatingWindow *_window;
    FloatingWidgetViewController *_menuViewController;
    FloatingContainerViewController *_containerViewController;
    FloatingWidgetViewController *_mainViewController;
    CGSize _mainViewControllerSize;
}

#pragma mark - Public

- (void)enable {
    if (_enabled) return;
    _enabled = YES;
    
    _containerViewController = [FloatingContainerViewController new];
    
    _window = [[FloatingWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.touchesDelegate = self;
    _window.rootViewController = _containerViewController;
    _window.hidden = NO;
    
    _menuViewController = [[FloatingMenuController alloc] initWithTitle:@"Setting"
                                                         withTitleColor:_titleColor
                                                          withTintColor:_tintColor];
    _menuViewController.presentationModeDelegate = self;
    
    self.presentationMode = FloatingPresentationModeCondensed;
}

- (void)disable {
    if (!_enabled) return;
    self.presentationMode = FloatingPresentationModeDisabled;
    _window = nil;
    _enabled = NO;
}

#pragma mark - Popover attaching

- (void)setPresentationMode:(FloatingPresentationMode)presentationMode {
    if (_presentationMode != presentationMode) {
        _presentationMode = presentationMode;
        switch (_presentationMode) {
            case FloatingPresentationModeFullWindow:
                [self _hideFloatingMenu];
                [self _showFloatingMainViewController];
                break;
            case FloatingPresentationModeCondensed:
                [self _hideFloatingMainViewController];
                [self _showFloatingMenuViewController];
                break;
            case FloatingPresentationModeDisabled:
                [self _hideFloatingMenu];
                [self _hideFloatingMainViewController];
                break;
        }
    }
}

#pragma mark - Main view controller presentation

- (void)setMainViewController:(FloatingWidgetViewController *)mainViewController {
    if (mainViewController) {
        _mainViewController = mainViewController;
        _mainViewController.presentationModeDelegate = self;
    }
}

- (void)setMainViewControllerSize:(CGSize)mainViewControllerSize {
    _mainViewControllerSize = mainViewControllerSize;
}

- (void)_showFloatingMainViewController {
    if (_mainViewController) {
        if (_mainViewControllerSize.width == 0 || _mainViewControllerSize.height == 0) {
            _mainViewControllerSize = CGSizeMake(MAXFLOAT, kFloatingMainSizeHeight);
        }
        [_containerViewController presentViewController:_mainViewController
                                               withSize:_mainViewControllerSize];
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"-[%@ %@]: property cannot be nil", NSStringFromClass([self class]), NSStringFromSelector(@selector(setMainViewController:))];
    }
}

- (void)_hideFloatingMainViewController {
    [_containerViewController dismissCurrentViewController];
}

#pragma mark - Floating menu presentation

- (void)_showFloatingMenuViewController {
    if (_menuViewController) {
        [_containerViewController presentViewController:_menuViewController
                                               withSize:CGSizeMake(kFloatingMenuSize,
                                                                   kFloatingMenuSize)];
    }
}

- (void)_hideFloatingMenu {
    [_containerViewController dismissCurrentViewController];
}

#pragma mark - FloatingPresentationModeDelegate

- (void)presentationDelegateChangePresentationModeToMode:(FloatingPresentationMode)mode {
    self.presentationMode = mode;
}

#pragma mark - FloatingWindowTouchedHandling

- (BOOL)window:(UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point {
    switch (self.presentationMode) {
        case FloatingPresentationModeFullWindow: {
            BOOL contains = CGRectContainsPoint(_mainViewController.view.bounds,
                                                [_mainViewController.view convertPoint:point
                                                                              fromView:window]);
            if (!contains && self.isAutoHideEnabled) {
                self.presentationMode = FloatingPresentationModeCondensed;
            }
            return contains;
        }
        case FloatingPresentationModeCondensed:
            return CGRectContainsPoint(_menuViewController.view.bounds,
                                       [_menuViewController.view convertPoint:point
                                                                     fromView:window]);
        case FloatingPresentationModeDisabled:
            return NO;
    }
}

@end
