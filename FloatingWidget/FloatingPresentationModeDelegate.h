//
//  FloatingPresentationModeDelegate.h
//  FloatingWidget
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FloatingPresentationModeDisabled = 0,
    FloatingPresentationModeFullWindow,
    FloatingPresentationModeCondensed,
} FloatingPresentationMode;

@protocol FloatingPresentationModeDelegate <NSObject>

- (void)presentationDelegateChangePresentationModeToMode:(FloatingPresentationMode)mode;

@end
