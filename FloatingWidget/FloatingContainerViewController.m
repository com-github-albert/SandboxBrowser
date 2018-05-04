//
//  FloatingContainerViewController.m
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "FloatingContainerViewController.h"
#import "FloatingMovable.h"

CGFloat SandboxRoundPixelValue(CGFloat value) {
    CGFloat scale = UIScreen.mainScreen.scale;
    return roundf(value * scale) / scale;
}

@implementation FloatingContainerViewController {
    UIViewController<FloatingMovable> *_presentedViewController;
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    UIPinchGestureRecognizer *_pinchGestureRecognizer;
    CGFloat _heightOnPinch;
    CGPoint _previousPinchingPoint;
    
    CGSize _size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)presentViewController:(UIViewController<FloatingMovable> *)viewController
                     withSize:(CGSize)size {
    if (_presentedViewController) {
        [self dismissCurrentViewController];
    }
    
    _presentedViewController = viewController;
    _size = size;
    CGSize adjustedSize = CGSizeMake(MIN(_size.width, CGRectGetWidth(self.view.bounds)),
                                     MIN(_size.height, CGRectGetHeight(self.view.bounds)));
    
    // Put content right under status bar, in the middle
    CGFloat heightOffset = 20;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets inset = self.view.safeAreaInsets;
        heightOffset = inset.top;
    }
    CGFloat widthOffset = SandboxRoundPixelValue((CGRectGetWidth(self.view.bounds) - adjustedSize.width) / 2.0);
    
    CGRect frame = CGRectMake(widthOffset, heightOffset, adjustedSize.width, adjustedSize.height);
    
    [self addChildViewController:_presentedViewController];
    _presentedViewController.view.frame = frame;
    [self.view addSubview:_presentedViewController.view];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [_presentedViewController.view addGestureRecognizer:_panGestureRecognizer];
    
    if ([_presentedViewController shouldStretchInMovableContainer]) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_pinch:)];
        [_presentedViewController.view addGestureRecognizer:_pinchGestureRecognizer];
    }
    
    [_presentedViewController didMoveToParentViewController:self];
}

- (void)presentViewController:(UIViewController<FloatingMovable> *)viewController
                     withRect:(CGRect)rect {
    if (_presentedViewController) {
        [self dismissCurrentViewController];
    }
    
    _presentedViewController = viewController;
    _size = rect.size;
    CGSize adjustedSize = CGSizeMake(MIN(_size.width, CGRectGetWidth(self.view.bounds)),
                                     MIN(_size.height, CGRectGetHeight(self.view.bounds)));
    
    // Put content right under status bar, in the middle
    CGFloat heightOffset = 20;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets inset = self.view.safeAreaInsets;
        heightOffset = inset.top;
    }
    CGFloat widthOffset = SandboxRoundPixelValue((CGRectGetWidth(self.view.bounds) - adjustedSize.width) / 2.0);
    
    CGRect frame = CGRectMake(widthOffset, heightOffset, adjustedSize.width, adjustedSize.height);
    
    [self addChildViewController:_presentedViewController];
    _presentedViewController.view.frame = frame;
    [self.view addSubview:_presentedViewController.view];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [_presentedViewController.view addGestureRecognizer:_panGestureRecognizer];
    
    if ([_presentedViewController shouldStretchInMovableContainer]) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_pinch:)];
        [_presentedViewController.view addGestureRecognizer:_pinchGestureRecognizer];
    }
    
    [_presentedViewController didMoveToParentViewController:self];
}

- (void)dismissCurrentViewController {
    if (!_presentedViewController) {
        return;
    }
    
    [_presentedViewController willMoveToParentViewController:nil];
    
    [_panGestureRecognizer removeTarget:self action:NULL];
    _panGestureRecognizer = nil;
    [_pinchGestureRecognizer removeTarget:self action:NULL];
    _pinchGestureRecognizer = nil;
    
    [_presentedViewController.view removeFromSuperview];
    [_presentedViewController removeFromParentViewController];
}

- (void)_pan {
    if (_panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [_presentedViewController containerWillMove:self];
    }
    
    CGPoint translation = [_panGestureRecognizer translationInView:self.view];
    
    CGPoint center = _presentedViewController.view.center;
    center.x += translation.x;
    center.y += translation.y;
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        inset = self.view.safeAreaInsets;
    } else {
        UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                inset = UIEdgeInsetsMake(20, 0, 0, 0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                inset = UIEdgeInsetsMake(0, 0, 20, 0);
                break;
            default:
                break;
        }
    }
    
    CGFloat centerHeightOffset = SandboxRoundPixelValue(CGRectGetHeight(_presentedViewController.view.frame) / 2.0 + inset.top);
    CGFloat centerWidthOffset = SandboxRoundPixelValue(CGRectGetWidth(_presentedViewController.view.frame) / 2.0) + inset.left;
    
    // Make sure it stays on screen
    if (center.y - centerHeightOffset < 0) {
        center.y = centerHeightOffset;
    }
    if (center.x - centerWidthOffset < 0) {
        center.x = centerWidthOffset;
    }
    
    CGFloat maximumY = CGRectGetHeight(self.view.bounds) -  CGRectGetHeight(_presentedViewController.view.frame) - inset.top - inset.bottom;
    if (center.y - centerHeightOffset > maximumY) {
        center.y = maximumY + centerHeightOffset;
    }
    
    CGFloat maximumX = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_presentedViewController.view.frame) - inset.right - inset.left;
    if (center.x - centerWidthOffset > maximumX) {
        center.x = maximumX + centerWidthOffset;
    }
    
    _presentedViewController.view.center = center;
    
    [_panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

- (void)_pinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _heightOnPinch = CGRectGetHeight(_presentedViewController.view.frame);
        
        [_presentedViewController containerWillMove:self];
    }
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        inset = self.view.safeAreaInsets;
    } else {
        UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                inset = UIEdgeInsetsMake(20, 0, 0, 0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                inset = UIEdgeInsetsMake(0, 0, 20, 0);
                break;
            default:
                break;
        }
    }
    
    CGFloat windowHeight = CGRectGetHeight(UIScreen.mainScreen.bounds) - inset.top - inset.bottom;
    
    CGFloat scale = gestureRecognizer.scale;
    CGFloat expectedHeight = scale * _heightOnPinch;
    expectedHeight = MAX(expectedHeight, [_presentedViewController minimumHeightInMovableContainer]);
    expectedHeight = MIN(expectedHeight, windowHeight);
    CGRect newFrame = _presentedViewController.view.frame;
    
    CGFloat yOffset = SandboxRoundPixelValue((expectedHeight - CGRectGetHeight(_presentedViewController.view.frame)) / 2.0);
    
    newFrame.size.height = expectedHeight;
    newFrame.origin.y -= yOffset;
    if (newFrame.origin.y <= inset.top) {
        newFrame.origin.y = inset.top;
    }
    
    if (newFrame.origin.y + expectedHeight >= windowHeight) {
        newFrame.origin.y = windowHeight - expectedHeight + inset.bottom;
    }
    
    _presentedViewController.view.frame = newFrame;
}

#pragma mark Keyboard Handling

- (void)_keyboardWillShow:(NSNotification *)notification {
    CGRect endFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardTopY = endFrame.origin.y;
    
    [self _pushPresentedViewAboveKeyboard:keyboardTopY];
}

- (void)_pushPresentedViewAboveKeyboard:(CGFloat)keyboardTopY {
    CGFloat rectBottom = CGRectGetMaxY(_presentedViewController.view.frame);
    if (rectBottom <= keyboardTopY) {
        return;
    }
    
    CGFloat difference = rectBottom - keyboardTopY;
    
    // Maximum height is measured from status bar to keyboard top line
    CGFloat maximumHeight = keyboardTopY - 20;
    CGFloat currentHeight = CGRectGetHeight(_presentedViewController.view.frame);
    CGFloat desiredHeight = (currentHeight > maximumHeight) ? maximumHeight : currentHeight;
    
    CGFloat yOffset = MAX(currentHeight - maximumHeight, 0);
    
    CGRect newFrame = CGRectMake(_presentedViewController.view.frame.origin.x,
                                 _presentedViewController.view.frame.origin.y - difference + yOffset,
                                 CGRectGetWidth(_presentedViewController.view.frame),
                                 desiredHeight);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self->_presentedViewController.view.frame = newFrame;
                     }];
}

#pragma mark Rotations

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        inset = self.view.safeAreaInsets;
    } else {
        UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                inset = UIEdgeInsetsMake(20, 0, 0, 0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                inset = UIEdgeInsetsMake(0, 0, 20, 0);
                break;
            default:
                break;
        }
    }
    
    static UIEdgeInsets originInset;
    
    CGRect frame = _presentedViewController.view.frame;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat x = (frame.origin.x - originInset.left) / viewHeight * viewWidth + inset.left;
    CGFloat y = (frame.origin.y - originInset.top) / viewWidth * viewHeight + inset.top;
    CGFloat w = MIN(_size.width, viewWidth - inset.left - inset.right);
    CGFloat h = MIN(_size.height, viewHeight - inset.top - inset.bottom);
    x = MAX(x, inset.left);
    y = MAX(y, inset.top);
    frame = CGRectMake(x, y, w, h);
    originInset = inset;
    
    self->_presentedViewController.view.frame = frame;
    
}

@end
