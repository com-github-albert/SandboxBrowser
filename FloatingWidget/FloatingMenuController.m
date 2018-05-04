//
//  FloatingMenuController.m
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "FloatingMenuController.h"

@implementation FloatingMenuController {
    UIButton *_menuButton;
    NSString *_title;
    UIColor *_titleColor;
    UIColor *_tintColor;
}

- (instancetype)initWithTitle:(NSString *)title
               withTitleColor:(UIColor *)titleColor
                withTintColor:(UIColor *)tintColor {
    self = [super init];
    if (self) {
        _title = title;
        _titleColor = titleColor;
        _tintColor = tintColor;
    }
    return self;
}

- (void)loadView {
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.view = _menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuButton.backgroundColor = _tintColor ?: [UIColor lightGrayColor];
    _menuButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _menuButton.titleLabel.textColor = _titleColor ?: [UIColor whiteColor];
    _menuButton.layer.borderWidth = 1.0;
    _menuButton.layer.borderColor = [UIColor grayColor].CGColor;
    _menuButton.alpha = 0.8;
    [_menuButton setTitle:_title forState:UIControlStateNormal];
    
    [_menuButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapped {
    [self.presentationModeDelegate presentationDelegateChangePresentationModeToMode:FloatingPresentationModeFullWindow];
}

@end
