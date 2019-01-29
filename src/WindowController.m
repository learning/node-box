//
//  WindowController.m
//  Node Box
//
//  Created by Learning on 2019/1/29.
//  Copyright © 2019 Learning. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reopen) name:@"reopen" object:nil];
}

- (void)reopen {
    [self.window makeKeyAndOrderFront:nil];
}

@end
