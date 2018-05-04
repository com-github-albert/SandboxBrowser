//
//  AppDelegate.m
//  SandboxBrowser
//
//  Created by Jett on 2018/5/2.
//  Copyright © 2018 <https://github.com/mutating>. All rights reserved.
//

#import "AppDelegate.h"
#import "FloatingWidget.h"
#import "SandboxViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) FloatingWidget *fw;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.fw = [FloatingWidget new];
    self.fw.mainViewController = [SandboxViewController new];
    self.fw.autoHideEnabled = YES;
    [self.fw enable];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.fw disable];
}

@end
