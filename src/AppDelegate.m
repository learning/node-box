//
//  AppDelegate.m
//  Node Box
//
//  Created by Learning on 2019/1/29.
//  Copyright © 2019 Learning. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reopen" object:nil];
    }
    return YES;
}

@end
