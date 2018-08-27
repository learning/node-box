//
//  AppDelegate.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        VersionManager.updateDownloadList()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            NotificationCenter.default.post(name: Notification.Name("reopen"), object: nil)
        }
        return true
    }
}

