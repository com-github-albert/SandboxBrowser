//
//  FloatingWidgetViewController.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloatingMovable.h"
#import "FloatingPresentationModeDelegate.h"

@interface FloatingWidgetViewController : UIViewController <FloatingMovable>

@property (nonatomic, weak) id<FloatingPresentationModeDelegate> presentationModeDelegate;

@end
