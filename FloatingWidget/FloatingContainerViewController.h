//
//  FloatingContainerViewController.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloatingMovable;

@interface FloatingContainerViewController : UIViewController

- (void)presentViewController:(UIViewController<FloatingMovable> *)viewController
                     withSize:(CGSize)size;

- (void)dismissCurrentViewController;

@end
